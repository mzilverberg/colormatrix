###!
----------------------------------
jquery.colorMatrix.js
----------------------------------
version:        1.1.3
last update:    June 6th, 2017
author:         Maarten Zilverberg
tested:         Webkit, FF31+, IE8+
----------------------------------
###
do ($ = jQuery, window, document) ->

    # Defaults
    pluginName = "colorMatrix"
    NS = {
        svg: "http://www.w3.org/2000/svg",
        xlink: "http://www.w3.org/1999/xlink"
    }
    defaults = {
        className:      "grayscale"
        type:           "saturate"
        ids:            ["desaturate", "normal"]
        values:         [0, 1]
    }

    # Plugin constructor
    class Plugin
        constructor: (element, options) ->
            @element = element
            # Merge settings with default options
            @settings = $.extend({}, defaults, options)
            @_defaults = defaults
            @_name = pluginName
            # Initiate
            @init()

        # Check for CSS filters support
        cssFiltersSupported: ->
            # Check if CSS filters are supported or whether an SVG fallback should be provided
            # [source]--> https://github.com/Modernizr/Modernizr
            el = document.createElement("div")
            prefixes = " -webkit- -moz- -o- -ms- ".split(" ")
            el.style.cssText = prefixes.join("filter: blur(2px); ")
            # Firefox v32 doesn't support CSS filters but does support SVG filters within CSS,
            # In order to prevent the fallback from failing, check if the CSS filter attribute is not "none" or undefined
            # (FireFox will use "data:image/svg+xml...")
            filter = $(@element).addClass(@settings.className).css("filter")
            # Check for support
            a = !!el.style.length or filter isnt "none"
            b = typeof document.documentMode is "undefined" or document.documentMode > 9
            a and b

        # Check if SVG images are supported
        svgSupported: ->
            # Check if CSS filters are supported or whether an SVG fallback should be provided
            # [source]--> https://github.com/Modernizr/Modernizr
            document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Image", "1.1")

        # Check if is old IE
        isOldIE: ->
            document.documentMode <= 9

        # Make calls to check if an image has been loaded
        checkImage: ->
            # Store `this` in a variable
            t = @
            iterations = 0
            # Define function to check whether image is loaded
            isImageLoaded = ->
                # Increment
                iterations++
                # If image is already loaded
                if t.completeImage()
                    yes
                else if iterations <= 100
                    window.setTimeout(isImageLoaded, 100)
                    return
                else
                    yes
            # Return true if image is loaded
            isImageLoaded()

        # Check if an image is loaded
        completeImage: ->
            # If image is not loaded, return false
            return no if !@element.complete
            return no if typeof @element.naturalWidth isnt "undefined" and @element.naturalWidth is 0
            # If image is loaded, return true
            yes

        # Create SVG Element
        # ---
        # @param `imgId` (string):  unique id
        # @param `w` (integer):     width of image
        # @param `h` (integer):     height of image
        createSVG: (imgId, w, h) ->
            # Create a new SVG element
            svg = document.createElementNS(NS.svg, "svg")
            svg.setAttribute("width", w)
            svg.setAttribute("height", h)
            $svg = $(svg)
            # Create SVG definitions
            @createSVGDefinitions($svg, imgId)
            # Add image to SVG
            @addImage($svg, imgId, w, h)
            # Return SVG element
            $svg

        # Create SVG definitions
        # ---
        # @param `$svg` (jQuery selector):    newly created SVG element
        # @param `imgId` (string):            unique id
        createSVGDefinitions: ($svg, imgId) ->
            # Create definitions element in SVG namespace
            defs = document.createElementNS(NS.svg, "defs")
            # Add filters
            i = 0
            while i < 2
                # Create filter element
                filter = document.createElementNS(NS.svg, "filter")
                filter.setAttribute("id", @settings.ids[i])
                # Define color matrix
                matrix = document.createElementNS(NS.svg, "feColorMatrix")
                matrix.setAttribute("type", @settings.type)
                matrix.setAttribute("values", @settings.values[i])
                # Add color matrix to filter and filter to definitions
                filter.appendChild(matrix)
                defs.appendChild(filter)
                i++
            # Add filters to SVG element
            $svg[0].appendChild(defs)
            return

        # Add image to SVG element
        # ---
        # @param `$svg` (jQuery selector):  newly created SVG element
        # @param `imgId` (string):          unique id
        # @param `w` (integer):             width of image
        # @param `h` (integer):             height of image
        addImage: ($svg, imgId, w, h) ->
            # Collect attributes
            attrs = {
                "id":           imgId
                "class":        @settings.className
                "width":        w
                "height":       h
                "x":            0
                "y":            0
                "href":         [@element.src, NS.xlink]
                "visibility":   "visible"
            }
            # Check if value is an array
            isArray = (val) ->
                Object.prototype.toString.call(val) is "[object Array]"
            # Create image
            img = document.createElementNS(NS.svg, "image")
            # Loop through attributes
            for key of attrs
                if attrs.hasOwnProperty(key)
                    # Add attribute to image
                    args = {
                        namespace:  if not isArray(attrs[key]) then null else attrs[key][1]
                        value:      if not isArray(attrs[key]) then attrs[key] else attrs[key][0]
                    }
                    img.setAttributeNS(args.namespace, key, args.value)
            # Append new image
            $svg.append(img)
            return

        # Apply grayscale to element
        apply: ->
            # Get image dimensions
            w = @element.width
            h = @element.height
            # Create a unique identifier for the current element
            # [source]--> https://gist.github.com/gordonbrander/2230317
            imgId = "img_#{Math.random().toString(36).substr(2, 9)}"
            # If CSS filters are supported or if the browser is IE9-
            if @cssFiltersSupported() or @isOldIE()
                # Rely on CSS filters
                $(@element).addClass(@settings.className)
                return
            # If SVG is not supported
            if not @svgSupported()
                # The fallback won't work, so throw an error
                throw new Error("#{pluginName}.js: SVG is not supported by this browser")
                return
            # Create a new SVG element
            $svg = @createSVG(imgId, w, h)
            # Insert SVG and hide original image
            $(@element).hide().after($svg)

        # Initiate
        init: ->
            if @checkImage(@element)
                @apply()

    # A really lightweight plugin wrapper around the constructor,
    # preventing against multiple instantiations
    $.fn[pluginName] = (options) ->
        # chain jQuery functions
        @each ->
            unless $.data(@, "plugin_#{pluginName}")
                $.data(@, "plugin_#{pluginName}", new Plugin(@, options))

    # Auto initiate on grayscale images
    $(window).on "load", ->
        $(".#{defaults.className}")[pluginName]()
    return
