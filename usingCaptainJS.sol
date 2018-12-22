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

    address CaptainsAddress = 0xc52f52057f6bf5ecc75d704cb85510f4e1ba207b; // v2

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

}

