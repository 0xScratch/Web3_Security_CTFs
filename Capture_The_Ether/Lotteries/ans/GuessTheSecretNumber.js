/*
    This level is kind of a bit clever than the last one, and ofcourse why it won't be

    We see that, now we aren't provided with the secret number which is clearly visible, but with a secrethash..and as we all know in the space of blockchain -> Hashes can't be converted back from the 'thing' they are derived from

    Yea, yea..we won't be doing a damn magic here and be reverting this, but yea we can still figure out the number
    If you have noticed the function `guess`, it's taking an argument as a number of `uint8`, and we know uint refers to unsigned integers (> 0) and thus, uint8 can only have value from 0 to 255

    Which makes us implement the below code and found out what hash is formed by this number!

    Rest of the work gonna done by you!
*/

const keccak256 = require('keccak256')

const secretHash = 'db81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365'

for(let i = 0; i < 256; i++){
    if(keccak256(i).toString('hex') === secretHash){
        console.log(i)
    }
}