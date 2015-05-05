(function($, window, document) {
  $(".sepia").colorMatrix({
    className: "sepia",
    matrixType: "matrix",
    ids: ["sepia", "normal"],
    values: ["0.393 0.769 0.189 0 0 0.349 0.686 0.168 0 0 0.272 0.534 0.131 0 0 0 0 0 1 0", "1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0"]
  });
})(jQuery, this, document);
