#Progress Bar Sample Credit 
#https://social.technet.microsoft.com/wiki/contents/articles/18697.an-example-of-using-write-progress-in-a-long-running-sharepoint-powershell-script.aspx

#The progress bar, is going to display the overall status of the function, which has four stages (steps), which are: 1. "One", 2. "Two", 3. "Three", and finally, 4. "Four"
$ProgressBarId = 0;
$numberOfActions = 4;

#Set the percentage of the first progress bar to 0%
Write-Progress -Id $ProgressBarId -Activity "Activity" -PercentComplete (0)

#Set the percentage of the first progress bar to 25% (calculated from (1/$numberOfActions *100), which is effectively 1/4*100)
Write-Progress -Id $ProgressBarId -Activity "Activity" -PercentComplete (1/$numberOfActions *100) -Status "Status";

#Set the percentage of the first progress bar to 50% (calculated from (2/$numberOfActions *100), which is effectily 2/4*100)            
Write-Progress -Id $ProgressBarId -Activity "Activity" -PercentComplete (3/$numberOfActions *100) -Status "Status";

#Set the percentage of the first progress bar to 75% (calculated from (3/$numberOfActions *100), which is effectively 3/4*100)
Write-Progress -Id $ProgressBarId -Activity "Activity" -PercentComplete (3/$numberOfActions *100) -Status "Status";

#Finally, update the progress bar with a success message, and set the percent complete to 100%
Write-Progress -Id $ProgressBarId -Activity "Activity" -PercentComplete (100) -Status "Status";
