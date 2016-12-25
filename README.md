# Option

The Option class store basic properties of a vanilla option include type (call/put), strike, underlying price, expire date, option price, and use Blent method for root finding to calculate implied volatility for black-scholes model. It can also override any properties to calculate its theoretic value for purpose like scenario analyst. It also provide function to calculate greeks.

### Installing

Simply add the Option.swift file in to your project and import it.

```
import Option

```
Or drag the whole "Option.xcproject" in to your project as your sub-project and add the Option.framework in to the Embedded Binaries section of your target's general setting, just like other usage of third-party framework.


## Versioning


## License


Copyright 2916 KuanHung Wang

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
