Set-StrictMode -Version Latest

if (-not ('FinancialAlert.NativeCredential' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;

namespace FinancialAlert {
    public static class NativeCredential {
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        private struct CREDENTIAL {
            public UInt32 Flags;
            public UInt32 Type;
            public string TargetName;
            public string Comment;
            public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
            public UInt32 CredentialBlobSize;
            public IntPtr CredentialBlob;
            public UInt32 Persist;
            public UInt32 AttributeCount;
            public IntPtr Attributes;
            public string TargetAlias;
            public string UserName;
        }

        [DllImport("advapi32.dll", EntryPoint = "CredWriteW", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern bool CredWrite(ref CREDENTIAL credential, UInt32 flags);

        [DllImport("advapi32.dll", EntryPoint = "CredReadW", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern bool CredRead(string target, UInt32 type, UInt32 flags, out IntPtr credentialPtr);

        [DllImport("advapi32.dll", SetLastError = true)]
        private static extern void CredFree(IntPtr credentialPtr);

        [DllImport("advapi32.dll", EntryPoint = "CredDeleteW", CharSet = CharSet.Unicode, SetLastError = true)]
        private static extern bool CredDelete(string target, UInt32 type, UInt32 flags);

        public static void Write(string target, string username, string secret) {
            if (String.IsNullOrWhiteSpace(target)) throw new ArgumentException("Credential target is required.");
            if (String.IsNullOrWhiteSpace(username)) throw new ArgumentException("Harness user ID is required.");
            if (String.IsNullOrEmpty(secret)) throw new ArgumentException("Harness token is required.");

            byte[] secretBytes = Encoding.Unicode.GetBytes(secret);
            IntPtr blob = Marshal.AllocHGlobal(secretBytes.Length);
            try {
                Marshal.Copy(secretBytes, 0, blob, secretBytes.Length);
                CREDENTIAL credential = new CREDENTIAL {
                    Flags = 0,
                    Type = 1,
                    TargetName = target,
                    Comment = "financial-alert-system Harness scheduled sync",
                    CredentialBlobSize = (UInt32)secretBytes.Length,
                    CredentialBlob = blob,
                    Persist = 2,
                    AttributeCount = 0,
                    Attributes = IntPtr.Zero,
                    TargetAlias = null,
                    UserName = username
                };
                if (!CredWrite(ref credential, 0)) throw new Win32Exception(Marshal.GetLastWin32Error());
            }
            finally {
                Array.Clear(secretBytes, 0, secretBytes.Length);
                Marshal.FreeHGlobal(blob);
            }
        }

        public static string[] Read(string target) {
            IntPtr credentialPtr;
            if (!CredRead(target, 1, 0, out credentialPtr)) throw new Win32Exception(Marshal.GetLastWin32Error());
            try {
                CREDENTIAL credential = (CREDENTIAL)Marshal.PtrToStructure(credentialPtr, typeof(CREDENTIAL));
                string secret = credential.CredentialBlob == IntPtr.Zero
                    ? String.Empty
                    : Marshal.PtrToStringUni(credential.CredentialBlob, (int)credential.CredentialBlobSize / 2);
                return new string[] { credential.UserName ?? String.Empty, secret ?? String.Empty };
            }
            finally {
                CredFree(credentialPtr);
            }
        }

        public static void Delete(string target) {
            if (!CredDelete(target, 1, 0)) {
                int error = Marshal.GetLastWin32Error();
                if (error != 1168) throw new Win32Exception(error);
            }
        }
    }
}
'@
}

function Set-HarnessStoredCredential {
    param(
        [Parameter(Mandatory)][string]$Target,
        [Parameter(Mandatory)][string]$Username,
        [Parameter(Mandatory)][Security.SecureString]$Token
    )

    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Token)
    try {
        $plainToken = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
        [FinancialAlert.NativeCredential]::Write($Target, $Username, $plainToken)
    }
    finally {
        if ($ptr -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
        $plainToken = $null
    }
}

function Get-HarnessStoredCredential {
    param([Parameter(Mandatory)][string]$Target)

    $values = [FinancialAlert.NativeCredential]::Read($Target)
    [pscustomobject]@{ Username = $values[0]; Token = $values[1] }
}

function Remove-HarnessStoredCredential {
    param([Parameter(Mandatory)][string]$Target)
    [FinancialAlert.NativeCredential]::Delete($Target)
}

