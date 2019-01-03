pragma solidity ^0.4.25;

contract ICaptainJS {
    function CalculatePrice(uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns(uint);
    function CalculateBellRing(uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns(uint);

    function GetPricePerBellRing() public view returns(uint);
    function GetPricePerSubmission() public view returns(uint);
    function GetPricePerSlice() public view returns(uint); 

    function ActivateVoucherCode(string VoucherCode) external;

    function RingShipsBell(uint UniqueIdentifier, uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) external payable;

    function RunWithVoucher(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei) external payable;
    function RunWithoutVoucher(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei) external payable;
            
}

contract usingCaptainJS {

    address CaptainsAddress = 0xc52f52057f6bf5ecc75d704cb85510f4e1ba207b; // MAINNET
    // address constant CaptainsAddressAtROPSTEN = 0x2cc6e8a4dd631fbb504e696231526b3a984c1e46;

    uint constant DEFAULT_GAS_PRICE = 3000000000 wei; // 3 gwei
    uint constant DEFAULT_GAS_UNITS = 100000;
    bool HasVoucher = false;

    constructor () internal {
    }

    function SetCaptainsAddress(address NewAddress) public {
        CaptainsAddress = NewAddress;
    }

    function ActivateVoucher(string VoucherCode) public {
        ICaptainJS(CaptainsAddress).ActivateVoucherCode(VoucherCode);
        HasVoucher = true;
    }

    // ------------------------------------------------------------------> JS Jobs

    function Run(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei) internal {
        // calculate the price            
        uint Price = ICaptainJS(CaptainsAddress).CalculatePrice(RuntimeSlices, GasForCallback, GasPriceInWei, HasVoucher);

        // check if this contract has enough money
        require(address(this).balance >= Price, "this contract does not have enough budget to execute JavaScript jobs");
        
        //transfer money to CaptainJS
        if(HasVoucher)
            ICaptainJS(CaptainsAddress).RunWithVoucher.value(Price)(UniqueJobIdentifier, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, GasForCallback, GasPriceInWei);
        else
            ICaptainJS(CaptainsAddress).RunWithoutVoucher.value(Price)(UniqueJobIdentifier, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, GasForCallback, GasPriceInWei);
    }

    function CaptainsResult(uint UniqueJobIdentifier, string Result) external onlyCaptainsOrdersAllowed {
        // override in your contract
    }
    
    function CaptainsError(uint UniqueJobIdentifier, string Error) external onlyCaptainsOrdersAllowed {
        // override in your contract
    }

    // ------------------------------------------------------------------> Ring Ring

    function RingShipsBell(uint UniqueJobIdentifier, uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei) internal {
        uint Price = ICaptainJS(CaptainsAddress).CalculateBellRing(InMinutesFromNow, GasForCallback, GasPriceInWei, HasVoucher);

        // check if this contract has enough money
        require(address(this).balance >= Price, "this contract does not have enough budget to ring the ship bell");
        
        //transfer money to CaptainJS
        ICaptainJS(CaptainsAddress).RingShipsBell.value(Price)(UniqueJobIdentifier, InMinutesFromNow, GasForCallback, GasPriceInWei, HasVoucher);
    }

    function RingRing(uint UniqueIdentifier) external onlyCaptainsOrdersAllowed {
        // override in your contract
    }

    modifier onlyCaptainsOrdersAllowed {
        require(
            msg.sender == CaptainsAddress,
            "row, row, row your boat seaman. Only the real captain can call this function..."
        );
        _;
    }


    // HELPERS

    
    function concat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function concat(string _a, string _b) internal pure returns (string){
        return concat(_a, _b, "", "", "");
    }

    function concat(string _a, string _b, string _c, string _d) internal pure returns (string){
        return concat(_a, _b, _c, _d, "");
    }

    function concat(string _a, string _b, string _c) internal pure returns (string){
        return concat(_a, _b, _c, "", "");
    }

    function uintToString(uint v) internal pure returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        str = string(s);
    }

    function StringToUint(string s) internal pure returns (uint result) {
        bytes memory b = bytes(s);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }

}

