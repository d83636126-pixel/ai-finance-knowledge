Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# Always operate on this script's vault root (canonical: D:\AI 金融知识点)
Set-Location -LiteralPath $PSScriptRoot

git status -sb
git add -A
$porcelain = git status --porcelain
if (-not $porcelain) {
  Write-Host 'Nothing to commit.'
  git status -sb
  exit 0
}

git commit -m "docs: enable Obsidian Git, finish 4.3 renames, start NFP project"
git push origin main
git log -1 --oneline
git status -sb
