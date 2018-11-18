pragma solidity ^0.4.24;

contract ICaptainJS {
    function CalculatePrice(uint RuntimeSlices, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns(uint);
    function Run(uint UniqueJobIdentifier, string JavaScriptCode, string InputParameter, string RequiredNpmPackages, uint RuntimeSlices, uint MaxOutputLength, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) external payable;
    
    function CalculateBellRing(uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) public view returns(uint);
    function RingShipsBell(uint UniqueIdentifier, uint InMinutesFromNow, uint GasForCallback, uint GasPriceInWei, bool HasVoucher) external payable;

    function ActivateVoucher(string VoucherCode) external;

    function CaptainIsOnDeck() external view returns(bool);

    function DepositMoreSilver(uint UniqueJobIdentifier) external payable;
}
