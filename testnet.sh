cp juno ~/.junotest
//binary before upgrade
git checkout 
go install ./...
junod start --home ~/.junotest 

//binary before upgrade
git checkout 
go install ./... --home ~/.junotest
