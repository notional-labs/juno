rm -rf ~/.junotest
cp juno ~/.junotest -r
//binary before upgrade
git checkout a5065a47a01cf063daf0c8d5f1ee74588eb9f24f
go install ./...
junod start --home ~/.junotest 


//binary before upgrade
git checkout f8bde9cc2897e6b369fe2ea299dacc5230bec5d9
go install ./... --home ~/.junotest
