pragma solidity ^0.4.25;

import "https://github.com/CaptainJavaScript/Solidity/usingCaptainJS_v2.sol";

contract SimpleTrust is usingCaptainJS {

    modifier onlyOwner {
        require(
            msg.sender == Owner,
            "row, row, row your boat seaman. Your captain's cabin is closed..."
        );
        _;
    }
    
    struct Member {
        uint Joined;
        address Wallet;
    }

    address Owner;
    Member[] Members;
    uint LastPayout;
 
    constructor() public payable {
        Owner = msg.sender;
        // start the process:
        DaysUntilNext15th();
    }

    uint constant DaysUntilNext15th_Id = 1;
    uint constant GetPayoutSum_Id = 3;

    function Payout() internal view {
        for (uint i=0; i<Members.length; i++)
            GetPayoutSum(i);             
    }
    
    function CaptainsResult(uint Id, string Result) external onlyCaptainsOrdersAllowed {
        if(Id == DaysUntilNext15th_Id) {
            uint Days = StringToUint(Result);
            if(Days > 0)
                CallbackBackOn15th(Days);
            else
                // it's the 15th!
                Payout();
        }
        else
            if(Id >= GetPayoutSum_Id) {
                uint Wei2Payout = StringToUint(Result);
                if(Wei2Payout > 0) 
                    Members[Id - GetPayoutSum_Id].Wallet.send(Wei2Payout); 
            }
    }

    function RingRing(uint Id) external onlyCaptainsOrdersAllowed {
        // it's the 15th!
        Payout();
    }

    function CallbackBackOn15th(uint Days) internal {
        RingShipsBell(0, Days * 24 * 60, DEFAULT_GAS_UNITS, DEFAULT_GAS_PRICE);
    }

    function DaysUntilNext15th() internal {
        string memory DaysUntilNext15th_JS = "eval:var moment=require('moment');var now=moment();CaptainJSOut=15-now.date();if(diff<0) CaptainJSOut=moment().month(1).diff(now,'days');";
        Run(DaysUntilNext15th_Id, DaysUntilNext15th_JS, "", "moment", 2, DEFAULT_GAS_UNITS, DEFAULT_GAS_PRICE);    
    }

    function GetPayoutSum(uint MemberId) internal {
        string memory GetPayoutSum_JS = "eval:var Now=new Date();var Member = new Date(CaptainJSIn);var YearsBetween=Now.getFullYear()-Member.getFullYear()-1;var MonthsBetween=Now.getMonth()-Member.getMonth()+1;if(MonthsBetween>0)YearsBetween++;const axios = require('axios');const toWei = 1000000000000000000;var Source = await axios.get('https://api.kraken.com/0/public/Ticker?pair=ETHUSD');var USDPrice = Source.data.result.XETHZUSD.a[0];var ETH2USD = 1 / USDPrice;var CaptainJSOut = YearsBetween * 50 * ETH2USD * toWei;";
        Run(GetPayoutSum_Id + MemberId, GetPayoutSum_JS, uintToString(Members[MemberId].Joined), "axios", 2, DEFAULT_GAS_UNITS, DEFAULT_GAS_PRICE);    
    }

    function NewMembership(address Wallet) external onlyOwner {
        Member memory NewMember = Member(now, Wallet);
        Members.push(NewMember);
    }

    function() payable external {}
}

/*
async function CheckPayout(CaptainJSIn) {
    var Now = new Date();
    var Member = new Date(CaptainJSIn);
    var YearsBetween = Now.getFullYear() - Member.getFullYear() - 1;
    var MonthsBetween = Now.getMonth() - Member.getMonth() + 1;
    if(MonthsBetween > 0)
        YearsBetween++;
    
    const axios = require('axios');
    const toWei = 1000000000000000000;
    var Source = await axios.get("https://api.kraken.com/0/public/Ticker?pair=ETHUSD");          
    var USDPrice = Source.data.result.XETHZUSD.a[0];
    var ETH2USD = 1 / USDPrice;
    var CaptainJSOut = YearsBetween * 50 * ETH2USD * toWei;
    return CaptainJSOut;
}

function DaysUntilNext15th(CaptainJSIn) {
    var moment = require('moment');
    moment().format();
    var now = moment();
    var diff = 15 - now.date();
    console.log(diff);
    if(diff >= 0)
        return diff;
    return moment().month(1).diff(now, 'days');
}

*/