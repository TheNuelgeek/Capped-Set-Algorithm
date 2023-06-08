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

        if (elements[addr].index == 0) {
            elements[addr].value = newValue;
            if (newValue < lowestValue) {
                lowestValue = newValue;
                return (addr, newValue);
            } else {
                return (address(0), 0);
            }
        }

        if (newValue >= lowestValue) {
            return (address(0), 0);
        }

        uint256 currentIndex = elements[addr].index;
        address evictedAddress = elementAddresses[currentIndex];
        elements[evictedAddress].value = newValue;
        elements[evictedAddress].index = currentIndex;
        elementAddresses[currentIndex] = addr;

        uint256 currentLowest = elements[evictedAddress].value;
        for (uint256 i = currentIndex + 1; i < elementAddresses.length; i++) {
            address currentAddress = elementAddresses[i];
            if (elements[currentAddress].value < currentLowest) {
                currentLowest = elements[currentAddress].value;
                evictedAddress = currentAddress;
            }
            elements[currentAddress].index = i - 1;
        }

        lowestValue = currentLowest;
        return (evictedAddress, currentLowest);
    }

    function remove(address addr) external returns (address, uint256) {
        require(addr != address(0), "Invalid address");
        require(elementAddresses.length > 0, "Set is empty");

        if (elements[addr].index == 0) {
            address evictedAddress = elementAddresses[0];
            uint256 currentLowest = elements[evictedAddress].value;
            for (uint256 i = 1; i < elementAddresses.length; i++) {
                address currentAddress = elementAddresses[i];
                if (elements[currentAddress].value < currentLowest) {
                    currentLowest = elements[currentAddress].value;
                    evictedAddress = currentAddress;
                }
                elements[currentAddress].index = i - 1;
            }

            delete elements[evictedAddress];
            elementAddresses[0] = elementAddresses[elementAddresses.length - 1];
            elementAddresses.pop();

            lowestValue = currentLowest;
            return (evictedAddress, currentLowest);
        }

        address lastAddress = elementAddresses[elementAddresses.length - 1];
        elements[lastAddress].index = elements[addr].index;
        elementAddresses[elements[addr].index] = lastAddress;
        elementAddresses.pop();

        delete elements[addr];
        return (address(0), 0);
    }

    function getValue(address addr) external view returns (uint256) {
        return elements[addr].value;
    }
}
