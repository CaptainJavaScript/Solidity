pragma solidity ^0.4.24;


contract usingCaptainJS {

    address CaptainsAddress = 0x72B272CFBFb14B128d096a275e0D135E0B95160F; // v1
    uint JobCounter;
    string VoucherCode;
    
    uint constant DEFAULT_GAS_PRICE = 2000000000 wei; // 2 gwei
    uint constant DEFAULT_GAS_UNITS = 21000;
    uint constant MAX_OUTPUT_LENGTH = 2**256 - 1;
    string constant NO_VOUCHER_CODE = "";
    bool HasVoucherCode = false;

    constructor () internal {
        JobCounter = 0;
        VoucherCode = NO_VOUCHER_CODE;
    }

    function SetCaptainsAddress(address NewAddress) public {
        CaptainsAddress = NewAddress;
    }

    function ChangeVoucherCode(string NewVoucherCode) {
        VoucherCode = NewVoucherCode;
        HasVoucherCode = bytes(VoucherCode).length > 0;
    }


    // ------------------------------------------------------------------> JS Jobs

    function Run(string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint MaxOutputLength, uint GasForCallback, uint GasPriceInWei) internal returns(uint UniqueJobIdentifier) {
        if(ICaptainJS(CaptainsAddress).CaptainIsOnDeck()) {
            UniqueJobIdentifier = ++JobCounter; 
            // calculate the price
            
            uint Price = ICaptainJS(CaptainsAddress).CalculatePrice(RuntimeSlices, GasForCallback, GasPriceInWei, HasVoucherCode);

            // check if this contract has enough money
            require(address(this).balance >= Price, "this contract does not have enough budget to execute JavaScript jobs");
            
            //transfer money to CaptainJS
            ICaptainJS(CaptainsAddress).Run.value(Price)(UniqueJobIdentifier, JavaScriptCode, InputParameter, RequiredNpmPackages, RuntimeSlices, MaxOutputLength, GasForCallback, GasPriceInWei, HasVoucherCode);

            return UniqueJobIdentifier;
        }
        else 
            return 0;
    }

    function CaptainsResult(uint UniqueJobIdentifier, string Result) external onlyCaptainsOrdersAllowed {
        // override in your contract
    }
    
    function CaptainsError(uint UniqueJobIdentifier, string Error) external onlyCaptainsOrdersAllowed {
        // override in your contract
    }

    // ------------------------------------------------------------------> Ring Ring

    function RingShipsBell(uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei) internal returns(uint UniqueJobIdentifier) {
        if(ICaptainJS(CaptainsAddress).CaptainIsOnDeck()) {
            UniqueJobIdentifier = ++JobCounter; 

            uint Price = ICaptainJS(CaptainsAddress).CalculateBellRing(InMinutesFromNow, GasForCallback, GasPriceInWei, HasVoucherCode);

            // check if this contract has enough money
            require(address(this).balance >= Price, "this contract does not have enough budget to ring the ship bell");
            
            //transfer money to CaptainJS
            ICaptainJS(CaptainsAddress).RingShipsBell.value(Price)(UniqueJobIdentifier, InMinutesFromNow, GasForCallback, GasPriceInWei, HasVoucherCode);

            return UniqueJobIdentifier;
        }
        else 
            return 0;
    }

    function RingRing(uint UniqueIdentifier) external onlyCaptainsOrdersAllowed {
        // override in your contract
    }

    // ------------------------------------------------------------------> More Silver, Seaman!

    function MoreSilverClaim(uint Silver, uint UniqueJobIdentifier) external {
        // override
        ICaptainJS(CaptainsAddress).DepositMoreSilver.value(Silver)(UniqueJobIdentifier);
    }   

    function AcceptSilver(uint UniqueJobIdentifier, string ReasonForPayBack) external payable {
        // override in your contract
    }

    // ------------------------------------------------------------------> Security

    modifier onlyCaptainsOrdersAllowed {
        require(
            msg.sender == CaptainsAddress,
            "row, row, row your boat seaman. Only the real captain can call this function..."
        );
        _;
    }

}

contract ICaptainJS {
    function CalculatePrice(uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns(uint);
    function Run(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint MaxOutputLength, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) external payable;
    
    function CalculateBellRing(uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns(uint);
    function RingShipsBell(uint UniqueIdentifier, uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) external payable;

    function ActivateVoucher(string VoucherCode) external;

    function CaptainIsOnDeck() external view returns(bool);

    function DepositMoreSilver(uint UniqueJobIdentifier) external payable;
}