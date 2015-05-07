# jQuery.colorMatrix.js

![Bower Version](https://img.shields.io/bower/v/jquery-colormatrix.svg)

A jQuery plugin for applying SVG and CSS [colormatrices](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/feColorMatrix) to inline images.

## Why?

You can easily apply **crossbrowser** color changes to images, as long as these changes are within the possibilities of `CSS` and `SVG` filters. By default, grayscale and inverted colors are supported*.

- Tested in Chrome, Firefox, Safari and IE8+
- Uses `CSS` filters if supported
- Extendable**

_*  Sepia tint is included, but doesn't work in IE version 9 and lower_

_** More options (for example: hue rotation) are possible. It's not currently integrated in the plugin, though._

## Installation

### Install with Bower

```
$ bower install jquery-colormatrix
```

### Or: include files

Include the plugin's `JavaScript` and `CSS` files. Have a look at the examples for further customization.

## Plugin options

The plugin accepts a few parameters:

<dl>
    <dt>className</dt>
    <dd>
        `string` - Name of the class that will be added to the image<br />
        _default: "grayscale"_
    </dd>
    <dt>type</dt>
    <dd>
        `string` - Type of the `<feColorMatrix>` element<br />
        _default: "saturate"_
    </dd>
    <dt>ids</dt>
    <dd>
        `array` - Identifiers for both `<feColorMatrix>` elements<br />
        _default: ["desaturate", "normal"]_
    </dd>
    <dt>values</dt>
    <dd>
        `array` - Colormatrix values for both `<feColorMatrix>` elements<br />
        _default: [0, 1]_
    </dd>
</dl>

## Examples

### Auto-trigger

Adding `class="grayscale"` to images will auto-trigger the plugin.

```html
<img src="path/to/image.png" alt="My image" class="grayscale" />
```

### Manual configuration

When applying the plugin through `JavaScript`, you have full control over the available options. You can invert colors by adding the following script to your site:

```javascript
$(".invert").colorMatrix({
    className:  "invert",
    type:       "matrix",
    ids:        ["invert", "normal"],
    values:     ["-1 0 0 0 1 0 -1 0 0 1 0 0 -1 0 1 0 0 0 1 0",
                 "1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0"]
})
```

Note that, if the browser supports `CSS` filters, `CSS` rules will be applied to the image. If you want to use a custom colormatrix, you should define it in both `JavaScript` as well as `CSS` (or `LESS`)
