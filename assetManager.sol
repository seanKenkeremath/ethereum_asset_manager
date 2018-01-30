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

    struct Asset {
        address owner;
        string name;
        uint id;
    }
    
    mapping (address => Asset[]) private assetsByOwner;
    mapping (uint => Asset) private assets;
    
    uint private assetIdCounter;

    function addAsset(string name) public {
        assetIdCounter++;
        
        Asset memory newAsset;
        newAsset.id = assetIdCounter;
        newAsset.name = name;
        newAsset.owner = msg.sender;
        
        assetsByOwner[msg.sender].push(newAsset);
        assets[newAsset.id] = newAsset;
    }
    
    function getAssetsById(address ownerAddress) public constant returns (uint[]) {
        uint[] memory assetIds = new uint[](assetsByOwner[ownerAddress].length);
        for (uint i = 0; i<assetsByOwner[ownerAddress].length; i++){
            assetIds[i] = assetsByOwner[ownerAddress][i].id;
        }
        return assetIds;
    }
    
    function getAssetName(uint assetId) public constant returns (string) {
        return assets[assetId].name;
    }
    
    function getAssetOwner(uint assetId) public constant returns (address) {
        return assets[assetId].owner;
    }
    
    function transferOwnership(uint assetId, address newOwner) public {
        if (assets[assetId].owner != msg.sender) {
            return;
        }
        uint indexToRemove = 0;
        for (uint i = 0; i<assetsByOwner[msg.sender].length; i++){
            if (assetsByOwner[msg.sender][i].id == assetId) {
                indexToRemove = i;
            }
        }
        assets[assetId].owner = newOwner;
        assetsByOwner[newOwner].push(assets[assetId]);
        
        assetsByOwner[msg.sender][indexToRemove] = assetsByOwner[msg.sender][assetsByOwner[msg.sender].length-1];
        assetsByOwner[msg.sender].length = assetsByOwner[msg.sender].length - 1;
    }
    
    function changeAssetName(uint assetId, string newName) public {
        if (assets[assetId].owner != msg.sender) {
            return;
        }
        assets[assetId].name = newName;
    }
    
    function removeAsset(uint assetId) public {
        if (assets[assetId].owner != msg.sender) {
            return;
        }
        
        uint indexToRemove = 0;
        for (uint i = 0; i<assetsByOwner[msg.sender].length; i++){
            if (assetsByOwner[msg.sender][i].id == assetId) {
                indexToRemove = i;
            }
        }
        
        assetsByOwner[msg.sender][indexToRemove] = assetsByOwner[msg.sender][assetsByOwner[msg.sender].length-1];
        assetsByOwner[msg.sender].length = assetsByOwner[msg.sender].length - 1;
        delete assets[assetId];
    }
}