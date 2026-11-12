// "One line misses the groups" — animated motivation of the parallel slopes
// model, RM26 L10. Data from L10-groups-data.js (written by make-figures.R).
//
// The figure follows the fragments of its slide (one state per click):
//   0  all 252 analysts in grey
//   1  the pooled OLS line: one line for everyone, gender ignored
//   2  the points take their group colours (men blue, women red)
//   3  the grey line splits: the parallel slopes lines slide out of it
// The pooled slope (14.4) and the common slope of the parallel slopes model
// (14.3) are almost identical, so the split is a pure vertical move.
(function () {
  var D = window.L10_GROUPS;
  var root = document.getElementById("groups-widget");
  if (!D || !root) return;

  var NS = "http://www.w3.org/2000/svg";
  var C = { blue: "#00395B", red: "#DF5541", gray: "#6F6F6F", light: "#A9A9A9", rule: "#E4E4E4" };
  var P = { x0: 105, x1: 785, y0: 470, y1: 20, ax: [20, 66], ay: [0, 3100] };
  function sx(v) { return P.x0 + (v - P.ax[0]) / (P.ax[1] - P.ax[0]) * (P.x1 - P.x0); }
  function sy(v) { return P.y0 - (v - P.ay[0]) / (P.ay[1] - P.ay[0]) * (P.y0 - P.y1); }
  function el(tag, attrs, parent, text) {
    var e = document.createElementNS(NS, tag);
    for (var k in attrs) e.setAttribute(k, attrs[k]);
    if (text !== undefined) e.textContent = text;
    (parent || svg).appendChild(e);
    return e;
  }

  var css = document.createElement("style");
  css.textContent =
    "#groups-widget circle { fill: " + C.light + "; fill-opacity: 0.45; transition: fill 0.9s; }" +
    "#groups-widget.s2 circle.m { fill: " + C.blue + "; }" +
    "#groups-widget.s2 circle.w { fill: " + C.red + "; }" +
    "#groups-widget .pooled { opacity: 0; transition: opacity 0.6s, stroke-width 0.6s; }" +
    "#groups-widget.s1 .pooled { opacity: 1; }" +
    "#groups-widget.s3 .pooled { opacity: 0.8; stroke-dasharray: 14 9; stroke-width: 4; }" +
    "#groups-widget .grp { opacity: 0; transition: transform 1.4s ease-in-out, opacity 0.3s; }" +
    "#groups-widget.s3 .grp { opacity: 1; transform: translate(0, 0) !important; }";
  document.head.appendChild(css);

  var svg = document.createElementNS(NS, "svg");
  svg.setAttribute("viewBox", "0 0 880 545");
  svg.setAttribute("width", "100%");
  svg.setAttribute("role", "img");
  svg.setAttribute("aria-label", "Earnings by age for 252 analysts: one grey line for everyone, " +
    "which splits into a higher line for men and a lower line for women");
  svg.style.fontFamily = "Inter, sans-serif";
  root.appendChild(svg);

  // axes
  [20, 30, 40, 50, 60].forEach(function (v) {
    el("line", { x1: sx(v), x2: sx(v), y1: P.y0, y2: P.y1, stroke: C.rule });
    el("text", { x: sx(v), y: P.y0 + 30, "text-anchor": "middle", "font-size": 20, fill: C.gray }, null, v);
  });
  [0, 1000, 2000, 3000].forEach(function (v) {
    el("line", { x1: P.x0, x2: P.x1, y1: sy(v), y2: sy(v), stroke: C.rule });
    el("text", { x: P.x0 - 10, y: sy(v) + 7, "text-anchor": "end", "font-size": 20, fill: C.gray },
       null, "$" + v.toLocaleString("en-US"));
  });
  el("text", { x: (P.x0 + P.x1) / 2, y: P.y0 + 64, "text-anchor": "middle", "font-size": 22, fill: C.blue }, null, "Age (years)");
  el("text", { x: 22, y: (P.y0 + P.y1) / 2, "text-anchor": "middle", "font-size": 22, fill: C.blue,
               transform: "rotate(-90 22 " + (P.y0 + P.y1) / 2 + ")" }, null, "Weekly earnings (USD)");

  // points
  for (var i = 0; i < D.age.length; i++) {
    el("circle", { cx: sx(D.age[i]), cy: sy(D.earn[i]), r: 6, "class": D.female[i] ? "w" : "m" });
  }

  // lines: pooled, and the two group lines starting on top of it
  var A0 = 24, A1 = 64, MID = 44;
  function yPooled(a) { return D.pooled[0] + D.pooled[1] * a; }
  function yGroup(a, f) { return D.par[0] + D.par[1] * a + D.par[2] * f; }
  el("line", { "class": "pooled", x1: sx(A0), y1: sy(yPooled(A0)), x2: sx(A1), y2: sy(yPooled(A1)),
               stroke: C.gray, "stroke-width": 6, "stroke-linecap": "round" });
  [[0, C.blue, "Men"], [1, C.red, "Women"]].forEach(function (g) {
    var shift = sy(yPooled(MID)) - sy(yGroup(MID, g[0]));
    var grp = el("g", { "class": "grp" });
    grp.style.transform = "translate(0px, " + shift + "px)";
    el("line", { x1: sx(A0), y1: sy(yGroup(A0, g[0])), x2: sx(A1), y2: sy(yGroup(A1, g[0])),
                 stroke: g[1], "stroke-width": 6, "stroke-linecap": "round" }, grp);
    el("text", { x: sx(A1) + 12, y: sy(yGroup(A1, g[0])) + 8, "font-size": 22, "font-weight": 700, fill: g[1] }, grp, g[2]);
  });

  // state from the fragments of the slide
  var slide = root.closest("section");
  function setState() {
    if (Reveal.getCurrentSlide() !== slide) return;
    var f = Reveal.getIndices().f;
    var s = (typeof f === "number" ? f : -1) + 1;
    root.className = ["s1", "s2", "s3"].filter(function (c, k) { return s > k; }).join(" ");
  }
  function hook() {
    Reveal.on("slidechanged", setState);
    Reveal.on("fragmentshown", setState);
    Reveal.on("fragmenthidden", setState);
    setState();
  }
  function start() {
    if (!window.Reveal) return;
    if (Reveal.isReady && Reveal.isReady()) hook(); else Reveal.on("ready", hook);
  }
  if (document.readyState === "complete") start();
  else window.addEventListener("load", start);
})();
