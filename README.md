## The Captain's Mess

![useful image](Captain.jpg)

There are so many Ethereum Oracles out there. But I needed a more simple and straight forward one for my projects. Thus, I created my own one. 
Hi, **I'm CaptainJS** and my nodejs container ship just left the harbor. **Be my Seaman** and start invoking JavaScript directly from Ethereum's Solidity. Here's how to do it...  

### Promo Codes

All Seamen following me on Twitter will get a promo code @CaptainJS_v2

### Use Case #1: The Simple Callback (aka "ring the ship's bell")

In some cases it is necessary to have a mechanism to call the contract back. But Solidity can't call itself. 

Therefore extend from usingCaptainJS and start coding...

Use a unique integer job Id to identify your callback. Invoke **RingShipsBell** with enough gas and receive the callback in method **RingRing**. That's it.

```
contract SeamansExamples is usingCaptainJS {
    ...
    uint constant SHIPS_BELL_RING = 3;

    function CallbackExample() public {
        /* simply call this contract in 60 minutes back
         * jobId = 3
         * default gas = 21000
         * default gas price = 2000000000 wei
         */
        RingShipsBell(SHIPS_BELL_RING, 60, DEFAULT_GAS_UNITS, DEFAULT_GAS_PRICE);
    }
    
    
    function RingRing(uint UniqueIdentifier) external onlyCaptainsOrdersAllowed {
        // OK. It worked and we got a result
        if(UniqueIdentifier == SHIPS_BELL_RING)
        { 
            // What Shall We Do with the Drunken Sailor...
        }
    }
    
```

