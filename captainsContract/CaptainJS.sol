pragma solidity ^0.4.25;

contract IsOwnableAndDestructable {
    address Owner;
    constructor () internal {
        Owner = msg.sender;
    }

    function Destruct() public onlyOwner {
        selfdestruct(Owner);
    }

    function Payout(uint Amount) public onlyOwner {
        address(Owner).transfer(Amount);
    }

    modifier onlyOwner {
        require(
            msg.sender == Owner,
            "row, row, row your boat seaman. Your captain's cabin is closed..."
        );
        _;
    }
}

contract ISeamanJS {

    function CaptainsResult(uint UniqueJobIdentifier,  string  Result) public;
    function CaptainsError(uint UniqueJobIdentifier, string  Error) public;

    function RingRing(uint UniqueIdentifier) public;
}

contract CaptainJS is IsOwnableAndDestructable {
    uint PricePerSlice;
    uint PricePerSubmission;
    uint PricePerBellRing;
    bool flag = false;

    constructor () public {
        // 0,01 USD = 50 szabo
        //CaptainOnDeck = true;

        PricePerSlice      =          50 szabo; // less than 0,01 USD
        PricePerSubmission =          20 szabo;
        PricePerBellRing   =           6 szabo; // 0,001
    }

    function () payable external {} 

    // ----------------------------------------------------------------------------------> JS Jobs

    function CalculatePrice(uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns(uint) {
        if(HasVoucher) 
            return GasForCallback * GasPriceInWei;
        else
            return PricePerSubmission + (RuntimeSlices * PricePerSlice) + (GasForCallback * GasPriceInWei);
    }

    function CalculateBellRing(uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns (uint) {
        if(HasVoucher) 
            return GasForCallback * GasPriceInWei;
        else
            return PricePerBellRing + PricePerSubmission + (GasForCallback * GasPriceInWei);
    }

    // ----------------------------------------------------------------------------------------------------------------------------------------------

    function ActivateVoucherCode(string VoucherCode) external {
        emit VoucherActivation(msg.sender, VoucherCode);
        flag = true;
    }
    
    event VoucherActivation(address Seaman, string VoucherCode);

    function RunWithVoucher(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei) external payable {
        uint Price = CalculatePrice(RuntimeSlices, GasForCallback, GasPriceInWei, true);

        require(msg.value >= Price, "row, row, row your boat seaman: budget underrun");
        
        emit NextJobToExecuteEvent(UniqueJobIdentifier, msg.sender, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, GasForCallback, GasPriceInWei, true);
    }

    function RunWithoutVoucher(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei) external payable {
        uint Price = CalculatePrice(RuntimeSlices, GasForCallback, GasPriceInWei, false);

        require(msg.value >= Price, "row, row, row your boat seaman: budget underrun");
        
        emit NextJobToExecuteEvent(UniqueJobIdentifier, msg.sender, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, GasForCallback, GasPriceInWei, false);
    }

    event NextJobToExecuteEvent(
        uint UniqueJobIdentifier, 
        address ClientAddress, 
        string JavaScriptCode, 
        string InputParameter, 
        string  RequiredNpmPackages, 
        uint RuntimeSlices, 
        uint GasForCallback, 
        uint GasPriceInWei, 
        bool HasVoucherCode);


    //-------------------------------------------------------------------------------------------------------------------------------------------


    function JSResult(address Seaman, uint UniqueJobIdentifier, string  Result, bool IsError) external onlyOwner {
        if(IsError)
            ISeamanJS(Seaman).CaptainsError(UniqueJobIdentifier, Result);
        else
            ISeamanJS(Seaman).CaptainsResult(UniqueJobIdentifier, Result);
    }

    event NextShipBell(uint UniqueIdentifier, uint InMinutesFromNow, address ClientAddress, uint GasForCallback, uint GasPriceInWei, bool HasVoucher);

    function RingShipsBell(uint UniqueIdentifier, uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) external payable {
        //require(CaptainOnDeck, "row, row, row your boat seaman: the captain is not on deck, sorry");

        uint Price = CalculateBellRing(InMinutesFromNow, GasForCallback, GasPriceInWei, HasVoucher);
        require(msg.value >= Price, "row, row, row your boat seaman: budget underrun");

        // OK. Enough Budget ;-)
        emit NextShipBell(UniqueIdentifier, InMinutesFromNow, msg.sender, GasForCallback, GasPriceInWei, HasVoucher);
    }

    function WakeUpSeaman(address Seaman, uint UniqueIdentifier) external onlyOwner {
        ISeamanJS(Seaman).RingRing(UniqueIdentifier);
    }

    // ----------------------------------------------------------------------------------> SETTERS / GETTERS

 
    function GetPricePerBellRing() public view returns(uint) {
        return PricePerBellRing;
    }

    function GetPricePerSubmission() public view returns(uint) {
        return PricePerSubmission;
    }

    function GetPricePerSlice() public view returns(uint) {
        return PricePerSlice;
    }
    
    function SetPricePerBellRing(uint Price) public onlyOwner {
        PricePerBellRing = Price;
    }

    function SetPricePerSubmission(uint Price) public onlyOwner {
        PricePerSubmission = Price;
    }

    function SetPricePerSlice(uint Price) public onlyOwner {
        PricePerSlice = Price;
    }

}
