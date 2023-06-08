// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract CappedSet {
    struct Element {
        uint256 value;
        uint256 index;
    }

    mapping(address => Element) private elements;
    address[] private elementAddresses;
    uint256 private maxSize;
    uint256 private lowestValue;
    uint256 private lowestValueAddressIndex;

    constructor(uint256 _maxSize) {
        require(_maxSize > 0, "Max size must be greater than 0");
        maxSize = _maxSize;
    }

    function insert(address addr, uint256 value) external returns (address, uint256) {
        require(addr != address(0), "Invalid address");
        require(value > 0, "Value must be greater than 0");

        // If this the first value insterted
        if (elementAddresses.length == 0) {
            elementAddresses.push(addr);
            elements[addr].value = value;
            elements[addr].index = 0;
            lowestValue = value;
            lowestValueAddressIndex = elements[addr].index;
            return (address(0), 0);
        }

        // If the element is not up to the max and the value added is less than the current lowest value
        if (elementAddresses.length < maxSize) {
            elementAddresses.push(addr);
            elements[addr].value = value;
            elements[addr].index = elementAddresses.length - 1;

            if (value < lowestValue) {
                lowestValue = value;
                lowestValueAddressIndex = elements[addr].index;
                return (addr, value);
            }else {
                return (elementAddresses[lowestValueAddressIndex], lowestValue);
            }

            
        }

        if (value == lowestValue) {
            return (elementAddresses[lowestValueAddressIndex], lowestValue);
        }
   
        address evictedAddress = elementAddresses[lowestValueAddressIndex];
        uint256 currentLowest = elements[evictedAddress].value;

        // Retained the container of the current lowest elements(value and address) and replaced the value with the new element. 
        elementAddresses[lowestValueAddressIndex] = addr;
        elements[addr].value = value;
        elements[addr].index = lowestValueAddressIndex;
        lowestValue = value;
        
        // I rechecked for the lowest value after adding the new element
        if (value < currentLowest) {
            lowestValueAddressIndex = elements[addr].index;
            return (addr, value);
        }else{
            for (uint256 i = 0; i < elementAddresses.length; i++) {
                address currentAddress = elementAddresses[i];
                if (elements[currentAddress].value < lowestValue) {
                    lowestValue = elements[currentAddress].value;
                    lowestValueAddressIndex = elements[currentAddress].index;
               }
                    
            }
        }
        
        return (elementAddresses[lowestValueAddressIndex], lowestValue);
    }

    function update(address addr, uint256 newValue) external returns (address, uint256) {
        require(addr != address(0), "Invalid address");
        require(newValue > 0, "Value must be greater than 0");
        require(addr == elementAddresses[elements[addr].index], "Address doesn't exist, use insert function");
        require(newValue != elements[addr].value, "You can't update the value with the same value");

        elements[addr].value = newValue;

        if (newValue < lowestValue) {
            lowestValueAddressIndex = elements[addr].index;
            lowestValue = newValue;
            return (addr, newValue);
        }

        return (elementAddresses[lowestValueAddressIndex], lowestValue);
    }


    function remove(address addr) external returns (address, uint256) {
        require(addr != address(0), "Invalid address");
        require(elementAddresses.length > 0, "Set is empty");
        require(addr == elementAddresses[elements[addr].index], "Address doesn't exist");

        uint256 indexToRemove = elements[addr].index;
        uint256 valueOfIndexToRemove = elements[addr].value;
        address lastAddress = elementAddresses[elementAddresses.length - 1];

        if (indexToRemove == elementAddresses.length - 1){
            elementAddresses.pop();
            delete elements[addr];
        }else if( elementAddresses.length == 1){
            elementAddresses.pop();
            delete elements[addr];
            lowestValueAddressIndex = 0;
            lowestValue = 0;
            return (address(0), 0);
        }else{

            elements[lastAddress].index = indexToRemove;
            elementAddresses[indexToRemove] = lastAddress;
            elementAddresses.pop();

            delete elements[addr];
        }


        if (valueOfIndexToRemove == lowestValue) {
            (lowestValue, lowestValueAddressIndex) = findLowestValue();
        } else if (elements[lastAddress].value == lowestValue) {
            lowestValueAddressIndex = indexToRemove;
        }

        return (elementAddresses[lowestValueAddressIndex], lowestValue);
    }



    function getValue(address addr) external view returns (uint256) {
        return elements[addr].value;
    }

    function findLowestValue() internal view returns (uint256, uint256) {
        uint256 lowest = lowestValue;
        uint256 lowestIndex = lowestValueAddressIndex;

        for (uint256 i = 0; i < elementAddresses.length; i++) {
            address currentAddress = elementAddresses[i];
            uint256 currentValue = elements[currentAddress].value;
            if (currentValue < lowest) {
                lowest = currentValue;
                lowestIndex = i;
            }
        }

        return (lowest, lowestIndex);
    }


}
