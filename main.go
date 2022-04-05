package main

import (
	"bufio"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/tendermint/spm/cosmoscmd"

	"github.com/CosmosContracts/juno/app"
)

type TxList struct {
	Txs []string
}

func DecodeTx(txBytes []byte) (sdk.Tx, error) {
	encoding := cosmoscmd.MakeEncodingConfig(app.ModuleBasics)
	tx, err := encoding.TxConfig.TxDecoder()(txBytes)
	if err != nil {
		return nil, err
	}
	return tx, nil
}

func LoadTxsFromFile(fileLocation string) ([]string, error) {
	file, err := os.Open(fileLocation)
	if err != nil {
		fmt.Println("Unable to open json at " + fileLocation)
		return nil, err
	}
	reader := bufio.NewReader(file)
	jsonData, _ := ioutil.ReadAll(reader)

	var txList TxList
	jsonErr := json.Unmarshal(jsonData, &txList)
	if jsonErr != nil {
		fmt.Println("Unable to map JSON at " + fileLocation + " to Investments")
		return nil, jsonErr
	}
	return txList.Txs, nil
}

func decodeTxFromBase64(base64Tx string) (sdk.Tx, error) {

	tx_byte, err := base64.StdEncoding.DecodeString(base64Tx)

	if err != nil {
		return nil, err
	}

	sdk_tx, err := DecodeTx(tx_byte)
	if err != nil {
		return nil, err
	}
	return sdk_tx, nil
}

func main() {
	base64Txs, err := LoadTxsFromFile("test_txs")
	if err != nil {
		panic(err)
	}
	for i, base64tx := range base64Txs {
		sdk_tx, err := decodeTxFromBase64(base64tx)
		fmt.Println("tx number " + strconv.Itoa(i))
		if err != nil {
			fmt.Println(err.Error())
			continue
		}

		for _, i := range sdk_tx.GetMsgs() {
			fmt.Printf("%+v\n", i)
		}
	}

}
