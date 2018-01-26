pragma solidity ^0.4.16;

/*

Copyright 2018 Sean Kenkeremath

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

contract AssetManager {
    
    mapping (address => uint[]) private assets;
    mapping (uint => address) private owners;
    mapping (uint => string) private assetNames;
    uint private assetIdCounter;

    function addAsset(string name) public {
        assetIdCounter++;
        assets[msg.sender].push(assetIdCounter);
        owners[assetIdCounter] = msg.sender;
        assetNames[assetIdCounter] = name;
    }
    
    function getAssets(address ownerAddress) public constant returns (uint[]) {
        return assets[ownerAddress];
    }
    
    function getOwner(uint assetId) public constant returns (address) {
        return owners[assetId];
    }
    
    function getAssetName(uint assetId) public constant returns (string) {
        return assetNames[assetId];
    }
    
    function transferOwnership(uint assetId, address newOwner) public {
        if (owners[assetId] != msg.sender) {
            return;
        }
        uint indexToRemove = 0;
        for (uint i = 0; i<assets[msg.sender].length; i++){
            if (assets[msg.sender][i] == assetId) {
                indexToRemove = i;
            }
        }
        owners[assetId] = newOwner;
        assets[newOwner].push(assetId);
        
        assets[msg.sender][indexToRemove] = assets[msg.sender][assets[msg.sender].length-1];
        assets[msg.sender].length = assets[msg.sender].length - 1;
    }
    
    function changeAssetName(uint assetId, string newName) public {
        if (owners[assetId] != msg.sender) {
            return;
        }
        assetNames[assetId] = newName;
    }
    
    function removeAsset(uint assetId) public {
        if (owners[assetId] != msg.sender) {
            return;
        }
        
        uint indexToRemove = 0;
        for (uint i = 0; i<assets[msg.sender].length; i++){
            if (assets[msg.sender][i] == assetId) {
                indexToRemove = i;
            }
        }
        
        assets[msg.sender][indexToRemove] = assets[msg.sender][assets[msg.sender].length-1];
        assets[msg.sender].length = assets[msg.sender].length - 1;
        owners[assetId] = 0;
        //Not removing the name
    }
}