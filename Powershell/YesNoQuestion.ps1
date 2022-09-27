$title1    = 'TITLE1'
$question1 = 'QUESTION1'
$choices1  = '&Yes','&No'
$title2     = "TITLE2"
$question2 = 'QUESTION2'

$decision1 = $Host.UI.PromptForChoice($title1, $question1, $choices1, 0)
if ($decision1 -eq 0) {
    Write-Host 'IF YES, DO SOMETHING AND, IF NO, MOVE ON'
    exit
} else {
    $decision2 = $Host.UI.PromptForChoice($title2, $question2, $choices1, 0)
    if ($decision2 -eq 0) {
        Write-Host 'IF YES, DO SOMETHING AND EXIT, IF NO, MOVE ON'
        exit
    } else {
        Clear-Host
        Write-Host 'NOTHING FUTHER, EXITING'
        }
}