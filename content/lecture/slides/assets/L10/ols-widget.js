// Least-squares animation for RM26 L10, slide "OLS picks the line ...".
//
// Left: twelve analysts (data from L10-ols-data.js, written by
// make-figures.R) and a candidate line with its residuals. Right: the sum of
// squared residuals as a function of the slope. The line always passes
// through the point of means, which is the best intercept for any given
// slope — so the right panel is exactly the criterion OLS minimises.
//
// The slide opens with a horizontal line (slope 0). The next click — an
// empty fragment, <span class="fragment" id="ols-play"> — starts the
// animation: the slope swings back and forth with shrinking amplitude and
// settles at the minimum (the OLS slope). Stepping back resets the line. The
// slider takes over by hand; "Replay" starts the animation again.
(function () {
  var D = window.L10_OLS;
  var root = document.getElementById("ols-widget");
  if (!D || !root) return;

  var NS = "http://www.w3.org/2000/svg";
  var C = { blue: "#00395B", teal: "#1C7F7B", red: "#DF5541", gray: "#6F6F6F", rule: "#E4E4E4" };
  var n = D.x.length;
  var mx = D.x.reduce(function (a, b) { return a + b; }, 0) / n;
  var my = D.y.reduce(function (a, b) { return a + b; }, 0) / n;
  var B_MIN = -40, B_MAX = 70;

  function ssr(b) {
    var a = my - b * mx, s = 0;
    for (var i = 0; i < n; i++) { var e = D.y[i] - a - b * D.x[i]; s += e * e; }
    return s;
  }
  var SSR_MAX = Math.max(ssr(B_MIN), ssr(B_MAX)) * 1.05;

  // ---- geometry (viewBox units) ----------------------------------------
  var L = { x0: 110, x1: 730, y0: 400, y1: 58, ax: [20, 60], ay: [0, 2500] };
  var R = { x0: 900, x1: 1370, y0: 400, y1: 58, ax: [B_MIN, B_MAX], ay: [0, SSR_MAX] };
  function sx(P, v) { return P.x0 + (v - P.ax[0]) / (P.ax[1] - P.ax[0]) * (P.x1 - P.x0); }
  function sy(P, v) { return P.y0 - (v - P.ay[0]) / (P.ay[1] - P.ay[0]) * (P.y0 - P.y1); }

  function el(tag, attrs, parent, text) {
    var e = document.createElementNS(NS, tag);
    for (var k in attrs) e.setAttribute(k, attrs[k]);
    if (text !== undefined) e.textContent = text;
    (parent || svg).appendChild(e);
    return e;
  }

  var svg = document.createElementNS(NS, "svg");
  svg.setAttribute("viewBox", "0 0 1400 470");
  svg.setAttribute("width", "92%");
  svg.style.display = "block";
  svg.style.margin = "0 auto";
  svg.setAttribute("role", "img");
  svg.setAttribute("aria-label", "Animated: a line rotates through twelve data points; " +
    "the sum of squared residuals is smallest at the OLS slope");
  svg.style.fontFamily = "Inter, sans-serif";
  root.appendChild(svg);

  // ---- axes ---------------------------------------------------------------
  function axes(P, xt, yt, xlab, ylab, xfmt, yfmt) {
    xt.forEach(function (v) {
      el("line", { x1: sx(P, v), x2: sx(P, v), y1: P.y0, y2: P.y1, stroke: C.rule });
      el("text", { x: sx(P, v), y: P.y0 + 30, "text-anchor": "middle", "font-size": 20, fill: C.gray }, null, xfmt(v));
    });
    yt.forEach(function (v) {
      el("line", { x1: P.x0, x2: P.x1, y1: sy(P, v), y2: sy(P, v), stroke: C.rule });
      if (yfmt) el("text", { x: P.x0 - 10, y: sy(P, v) + 7, "text-anchor": "end", "font-size": 20, fill: C.gray }, null, yfmt(v));
    });
    el("text", { x: (P.x0 + P.x1) / 2, y: P.y0 + 62, "text-anchor": "middle", "font-size": 22, fill: C.blue }, null, xlab);
    el("text", { x: P.x0 - (yfmt ? 85 : 20), y: (P.y0 + P.y1) / 2, "text-anchor": "middle", "font-size": 22, fill: C.blue,
                 transform: "rotate(-90 " + (P.x0 - (yfmt ? 85 : 20)) + " " + (P.y0 + P.y1) / 2 + ")" }, null, ylab);
  }
  axes(L, [20, 30, 40, 50, 60], [0, 500, 1000, 1500, 2000, 2500], "Age (years)", "Weekly earnings (USD)",
       function (v) { return v; }, function (v) { return "$" + v.toLocaleString("en-US"); });
  axes(R, [-40, -20, 0, 20, 40, 60], [], "Slope of the line (USD per year)", "Sum of squared residuals",
       function (v) { return v; }, null);

  // ---- right panel: the criterion as a function of the slope ---------------
  var pts = [];
  for (var b = B_MIN; b <= B_MAX + 1e-9; b += 0.5) pts.push(sx(R, b) + "," + sy(R, ssr(b)));
  el("polyline", { points: pts.join(" "), fill: "none", stroke: C.gray, "stroke-width": 3 });
  var minMark = el("g", { opacity: 0 });
  el("line", { x1: sx(R, D.b1), x2: sx(R, D.b1), y1: R.y0, y2: sy(R, ssr(D.b1)), stroke: C.teal,
               "stroke-width": 2.5, "stroke-dasharray": "7 5" }, minMark);
  el("text", { x: sx(R, D.b1) + 14, y: sy(R, ssr(D.b1)) + 44, "text-anchor": "start", "font-size": 22,
               "font-weight": 700, fill: C.teal }, minMark, "minimum = OLS");

  // ---- left panel: residuals, line, points -------------------------------
  var resid = [];
  for (var i = 0; i < n; i++) resid.push(el("line", { stroke: C.red, "stroke-width": 3, opacity: 0.8 }));
  var line = el("line", { stroke: C.teal, "stroke-width": 5, "stroke-linecap": "round" });
  for (var j = 0; j < n; j++) {
    el("circle", { cx: sx(L, D.x[j]), cy: sy(L, D.y[j]), r: 9, fill: C.blue, "fill-opacity": 0.85 });
  }
  var dot = el("circle", { r: 11, fill: C.red });
  var readSlope = el("text", { x: L.x0, y: 30, "font-size": 24, "font-weight": 700, fill: C.teal });
  var readSSR = el("text", { x: R.x0, y: 30, "font-size": 24, "font-weight": 700, fill: C.red });

  // ---- controls -------------------------------------------------------------
  var bar = document.createElement("div");
  bar.style.cssText = "display:flex;align-items:center;gap:0.8em;margin:0.2em 0 0 6%;font-size:0.6em;color:" + C.gray;
  var btn = document.createElement("button");
  btn.textContent = "▶ Replay";
  btn.style.cssText = "font:inherit;color:#fff;background:" + C.blue + ";border:0;padding:0.25em 0.8em;cursor:pointer";
  var lab = document.createElement("span");
  lab.textContent = "Slope by hand:";
  var slider = document.createElement("input");
  slider.type = "range"; slider.min = B_MIN; slider.max = B_MAX; slider.step = 0.5;
  slider.style.width = "40%";
  bar.appendChild(btn); bar.appendChild(lab); bar.appendChild(slider);
  root.appendChild(bar);

  function draw(b) {
    var a = my - b * mx;
    line.setAttribute("x1", sx(L, L.ax[0])); line.setAttribute("y1", sy(L, a + b * L.ax[0]));
    line.setAttribute("x2", sx(L, L.ax[1])); line.setAttribute("y2", sy(L, a + b * L.ax[1]));
    for (var i = 0; i < n; i++) {
      var yh = a + b * D.x[i];
      resid[i].setAttribute("x1", sx(L, D.x[i])); resid[i].setAttribute("x2", sx(L, D.x[i]));
      resid[i].setAttribute("y1", sy(L, D.y[i])); resid[i].setAttribute("y2", sy(L, yh));
    }
    var s = ssr(b);
    dot.setAttribute("cx", sx(R, b)); dot.setAttribute("cy", sy(R, s));
    readSlope.textContent = "slope = " + b.toFixed(1);
    readSSR.textContent = "Σ e² = " + (s / 1e6).toFixed(2) + " million";
    minMark.setAttribute("opacity", Math.abs(b - D.b1) < 0.6 ? 1 : 0);
    slider.value = b;
  }

  // ---- animation: damped swing around the OLS slope -------------------------
  // b(t) = b1 + A e^(-t/tau) cos(w t + phi), with phi chosen so that b(0) = 0:
  // the line starts horizontal, first tilts the wrong way, then settles.
  var A = 50, TAU = 3.2, W = 2 * Math.PI / 3.4;
  var PHI = Math.acos(-D.b1 / A);
  var raf = null, t0 = null, DUR = 11000;
  function frame(ts) {
    if (t0 === null) t0 = ts;
    var t = (ts - t0) / 1000;
    var b = D.b1 + A * Math.exp(-t / TAU) * Math.cos(W * t + PHI);
    draw(Math.max(B_MIN, Math.min(B_MAX, b)));
    if (ts - t0 < DUR) raf = requestAnimationFrame(frame);
    else { draw(D.b1); raf = null; }
  }
  function play() { stop(); t0 = null; raf = requestAnimationFrame(frame); }
  function stop() { if (raf) cancelAnimationFrame(raf); raf = null; }

  btn.addEventListener("click", function () { play(); btn.blur(); });
  slider.addEventListener("input", function () { stop(); draw(parseFloat(slider.value)); });
  slider.addEventListener("change", function () { slider.blur(); });

  draw(0);
  var slide = root.closest("section");
  var trigger = document.getElementById("ols-play");
  function reset() {
    stop();
    // arriving from a later slide (trigger already shown): show the result
    draw(trigger && trigger.classList.contains("visible") ? D.b1 : 0);
  }
  function hook() {
    Reveal.on("slidechanged", function (ev) { if (ev.currentSlide === slide) reset(); else stop(); });
    Reveal.on("fragmentshown", function (ev) { if (ev.fragment === trigger) play(); });
    Reveal.on("fragmenthidden", function (ev) { if (ev.fragment === trigger) { stop(); draw(0); } });
    if (Reveal.getCurrentSlide() === slide) reset();
  }
  // reveal.js is loaded after the slides, so wait for the page first.
  function start() {
    if (!window.Reveal) return;
    if (Reveal.isReady && Reveal.isReady()) hook(); else Reveal.on("ready", hook);
  }
  if (document.readyState === "complete") start();
  else window.addEventListener("load", start);
})();
