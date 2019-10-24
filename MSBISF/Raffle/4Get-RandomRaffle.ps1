$Evals = $(foreach ($line in Get-Content "C:\fleitasarts\rig\MSBISF\Raffle\2Eval.txt") {$line.tolower().split(" ")}) | sort | Get-Unique
echo $Evals > "C:\fleitasarts\rig\MSBISF\Raffle\unique-sorted.txt"
Get-Random -Input $Evals -Count 2 > "C:\fleitasarts\rig\MSBISF\Raffle\Winners.txt"
