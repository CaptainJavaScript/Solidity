## The Captain's Mess

![useful image](Captain.jpg)

There are so many Ethereum Oracles out there. But I needed a more simple and straight forward one for my projects. Thus, I created my own one. 
Hi, **I'm CaptainJS** and my nodejs container ship just left the harbor. **Be my Seaman** and start invoking JavaScript directly from Ethereum's Solidity. Here's how to do it...  

### Promo Codes

All Seamen following me on Twitter will get a promo code @CaptainJS_v2
Further details see "promo" section at the end.

### Use Case #1: The Simple Callback (aka "ring the ship's bell")

In some cases it is necessary to have a mechanism to call the contract back. For example a fond which withdraws its budget every year to specific people. But Solidity can't call itself.  

Therefore extend from usingCaptainJS and start coding...

Use a unique integer job Id to identify your callback. Invoke **_RingShipsBell_** with enough gas and receive the callback in method **_RingRing_**. That's it.

To make sure that **_RingRing_** will only be called by the captain himself and not a pirate, add **_onlyCaptainsOrdersAllowed_** to its declaration.

At the moment the captain can only accept bell rings with a **maximum of 48 hours**.

```solidity
contract SeamansExamples is usingCaptainJS {
    ...
    uint constant SHIPS_BELL_RING = 3;

    function CallbackExample() public {
        /* simply call this contract in 60 minutes back
         * jobId = 3
         * default gas = 70000 (defined in usingCaptainJS)
         * default gas price = 2000000000 wei (defined in usingCaptainJS)
         */
        RingShipsBell(SHIPS_BELL_RING, 60 /* minutes */, DEFAULT_GAS_UNITS, DEFAULT_GAS_PRICE);
    }
    
    
    function RingRing(uint UniqueIdentifier) external onlyCaptainsOrdersAllowed {
        // OK. It worked and we got a callback
        if(UniqueIdentifier == SHIPS_BELL_RING)
        { 
            // What Shall We Do with the Drunken Sailor...
        }
    }
    
```

### Use Case #2: The Simple JavaScript Job

Now let's look at a simple JavaScript job. JavaScript's _mathjs_ library has multiple useful functions such as _the conversion of centimeter to inch_. 

In order to use this library you need to call the **_Run_** function and hand over the JavaScript code that is necessary to convert centimeters to inch.

The JavaScript code you want to submit must be written the following way:
```JavaScript
module.exports = function(CaptainJSIn) { /* here goes your code */ } 
```
CaptainJS will invoke your code within a container by calling the default function. **_CaptainJSIn_** will contain your inputs of the JavaScript function. Then CaptainJS will return the result of your code.
If your JavaScript code was successful: **_CaptainsResult_** will be invoked. The return result is always a _string_.

If your JavaScript code was not successful _or_ its result couldn't be send back (it failed _or_ there was not enough gas _or_ whatever happened) then **_CaptainsError_** will be invoked.

To make sure that both **_CaptainsResult_** and **_CaptainsError_** will only be called by the captain himself and not a pirate, add **_onlyCaptainsOrdersAllowed_** to its declaration.

A **runtime slice** has a duration of 10 seconds and it includes the download and install of all required npm modules.

Here's the complete code snippet:

```solidity
contract SeamansExamples is usingCaptainJS {
    ...
    uint constant CENTIMETER_JOB = 1;

    function CentimeterToInchExample(string Centimeter) public returns (uint JobId) {
        bool Success = Run(
            /* give the job a unique ID */
            CENTIMETER_JOB,
            /* JavaScript code I want to execute: */
            "module.exports = function(CaptainJSIn) { var math = require('mathjs'); return math.eval(CaptainJSIn + ' cm to inch'); }", 
            /* Input parameter */
            Centimeter,
            /* Nodejs libraries we need */
            "mathjs", 
            /* we need a maximum of 2 runtime slices */
            2, 
            /* the returned string will have default maximum size */
            MAX_OUTPUT_LENGTH, 
            /* we will transfer gas units for return */
            70000, 
            /* we will transfer the default gas price for return */
            DEFAULT_GAS_PRICE
        );    
   }

   function CaptainsResult(uint UniqueJobIdentifier, string Result) external onlyCaptainsOrdersAllowed {
       // analyse the return results
       if(UniqueJobIdentifier == CENTIMETER_JOB) {
           // OK. It worked and we got a result
       } 
    }
    
    function CaptainsError(uint UniqueJobIdentifier, string Error) external onlyCaptainsOrdersAllowed {
        // analyse the return results
        if(UniqueJobIdentifier == CENTIMETER_JOB) {
            // OK. It didn't work :-/
        }
    }

}    
```

### Use Case #3: The Heavy JavaScript Job

Now let's look at a more complex JavaScript job. You want to ask **WolframAlpha** anything it knows about a country like _France_. Therefore you design your code the same way like you did in **Use Case #2**. 

To query WolframAlpha you use JavaScript's _axios_ library. The default function must be _async_ so that you can wait for a result when you invoke _axios.get(...)_. _axios_ will return a JSON object but we need to flatten it to a _string_:

```JavaScript
module.exports = async function(CaptainJSIn) { 
    const axios = require('axios');
    const WAlpha = await axios.get('http://www.wolframalpha.com/queryrecognizer/query.jsp?appid=DEMO&mode=Default&i=' + CaptainJSIn + '&output=json');          
    return JSON.stringify(WAlpha.data);
}
```
Again, CaptainJS will invoke your code within a container by calling this default function. **_CaptainJSIn_** will contain your inputs such as _"France"_. 

Again, if your JavaScript code was successful: **_CaptainsResult_** will be invoked. Otherwise **_CaptainsError_** will be invoked.

And because Solidity sometimes is such a crappy programming language you will use a very expensive **_concat_** function to make your JavaScript code more readable. 

You will submit this JavaScript code by accident with **_DEFAULT_GAS_PRICE_** of 21,000 which will be not enough because the return value of your WolframAlpha job is very long. _(see what will happen then in section **what if?**)_

Here's the complete code snippet. 

```solidity
contract SeamansExamples is usingCaptainJS {
    ...
    uint constant WOLFRAMALPHA_JOB = 2;
    
    function CentimeterToInchExample(string Centimeter) public returns (uint JobId) {
     bool Success = Run(
            /* give the job a unique ID */
            WOLFRAMALPHA_JOB,
            /* JavaScript code I want to execute: */
            concat (
                "module.exports = async function(CaptainJSIn) { ",
                "   const axios = require('axios'); ",
                "   const WAlpha = await axios.get('http://www.wolframalpha.com/queryrecognizer/query.jsp?appid=DEMO&mode=Default&i=' + CaptainJSIn + '&output=json'); ",          
                "   return JSON.stringify(WAlpha.data); ",
                "}"
            ),
            /* Input parameter */
            Country,
            /* Nodejs libraries we need */
            "axios", 
            /* we need a maximum of 2 runtime slices */
            2, 
            /* the returned string will have default maximum size */
            MAX_OUTPUT_LENGTH, 
            /* we will transfer the default amount of gas units for return */
            DEFAULT_GAS_UNITS, 
            /* we will transfer the default gas price for return */
            DEFAULT_GAS_PRICE
        );    
      }
      
      ...
}    
```

### What If? 

+ _what if_ you don't transfer enough **gas**?
    - then your job won't fail directly.
    - the captain will try his best to get the job back on the blockchain
    - he will calculate the budget you submitted when calling **_Run(...)_** as _budget = 350000 * max possible gas_price_
    - if your job result then still doesn't go through, then good night
    
+ _what if_ you transfer too much **gas** and a too high **gas price**?
    - then the captain will order a bottle of rum on your expense
    
+ _what if_ it a callback is delayed (ie. it is invoked after 2 days instead of 2 hours)
    - the captain then will argue that the concept of blockchain isn't made for exacted invocations
    - be mentally prepared then
    - transfer a higher budget next time by increasing **gas** and **gas price**
    
+ _what if_ a JavaScript code never gets executed?
    - relax
    - the captain then will shout "**impossible!**" and try its best by informing you via **_CaptainsError_** invocati### What If? 

+ _what if_ you change code within **_usingCaptainJS_**?
    - you won't be keelhauled :-)
    - try it, improve it!

+ _what if_ you submit _bad_ code?
    - we don't like pirates!
    - this is not nice!



### Prices & Budget Transfer
The Captain just rented his container ship. To pay his ship he needed to set these prices. Prices may change over time and will be updated both here + via Twitter.

+ _**RingShipsBell**(...)_: 
    - if you have a promo code then you transfer the price per submission plus your gas budget for the callback
    - otherwise the full price needs to be payed
    - **_PricePerSubmission_** = _20 szabo_;
    - **_PricePerBellRing_**   = _6 szabo_; // 0,001
 
```Solidity
        if(HasVoucher) 
            return PricePerSubmission + (GasForCallback * GasPriceInWei);
        else
            return PricePerBellRing + PricePerSubmission + (GasForCallback * GasPriceInWei);
```

+ _**Run**(...)_: 
    - if you have a promo code then you transfer the price per submission plus your gas budget for the callback
    - otherwise the full price needs to be payed
    - **_PricePerSubmission_** = _20 szabo_;
    - **_PricePerSlice_**      = _50 szabo_; // 1 slice = 10 seconds
 
```Solidity
        if(HasVoucher) 
            return PricePerSubmission + (GasForCallback * GasPriceInWei);
        else
            return PricePerSubmission + (RuntimeSlices * PricePerSlice) + (GasForCallback * GasPriceInWei);
```


### Promo Codes

Inside your **_usingCaptainJS_** there is a promo context included. Just add your voucher code here or call **_ChangeVoucherCode_** from your derived Solidity code. 

```Solidity
    string VoucherCode;
    string constant NO_VOUCHER_CODE = "";
    
    constructor () internal {
        ...
        VoucherCode = NO_VOUCHER_CODE;
    }

    function ChangeVoucherCode(string NewVoucherCode) {
        VoucherCode = NewVoucherCode;
        HasVoucherCode = bytes(VoucherCode).length > 0;
    }
```


