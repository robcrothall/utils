Get-ChildItem |
Where-Object { $_.PSIsContainer } |
ForEach-Object {
  $_.Name + ": " + (
    Get-ChildItem $_ -Recurse |
    Measure-Object Length -Sum -ErrorAction SilentlyContinue
  ).Sum
}
