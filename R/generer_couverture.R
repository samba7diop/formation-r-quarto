# Génère une variante PNG imprimable de la couverture avec les graphiques de base de R.
# Exécution depuis la racine du projet : Rscript R/generer_couverture.R

dir.create("resources/images", recursive = TRUE, showWarnings = FALSE)
png("resources/images/couverture.png", width = 1200, height = 1500, res = 160)
op <- par(no.readonly = TRUE)
par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i", bg = "#082f32")
plot.new()
plot.window(xlim = c(0, 9), ylim = c(0, 11.25), asp = NA)

# Dégradé vert profond : bandes fines, sans dépendance externe.
palette_fond <- grDevices::colorRampPalette(c("#082f32", "#10534f", "#13766b"))(320)
for (i in seq_along(palette_fond)) {
  y0 <- 11.25 * (i - 1) / length(palette_fond)
  y1 <- 11.25 * i / length(palette_fond)
  rect(0, y0, 9, y1, col = palette_fond[i], border = NA)
}

# Trame discrète et cercles d'observation en haut à droite.
for (x in seq(0, 9, by = .48)) segments(x, 0, x, 11.25, col = grDevices::adjustcolor("#e8f1e9", .055))
for (y in seq(0, 11.25, by = .48)) segments(0, y, 9, y, col = grDevices::adjustcolor("#e8f1e9", .055))
symbols(rep(7.2, 3), rep(8.9, 3), circles = c(1.65, 1.25, .84), inches = FALSE, add = TRUE,
        fg = vapply(c(.14, .13, .12), function(a) grDevices::adjustcolor("#f6e8c8", alpha.f = a), character(1)),
        lwd = 1.2)

# Graphique stylisé : histogramme et courbe de tendance.
xleft <- .95
xright <- 7.95
ybase <- 2.05
ytop <- 6.55
for (yy in seq(ybase + .8, ytop, by = .9)) {
  segments(xleft, yy, xright, yy, col = grDevices::adjustcolor("#f7faf7", .12), lty = 3)
}
segments(xleft, ybase, xright, ybase, col = grDevices::adjustcolor("#f7faf7", .48), lwd = 1.4)
segments(xleft, ybase, xleft, ytop, col = grDevices::adjustcolor("#f7faf7", .48), lwd = 1.4)
centres <- seq(1.35, 7.35, length.out = 7)
hauteurs <- c(1.3, 2.0, 1.75, 2.75, 2.45, 3.55, 3.25)
for (i in seq_along(centres)) {
  rect(centres[i] - .23, ybase, centres[i] + .23, ybase + hauteurs[i],
       col = grDevices::adjustcolor("#e8ad4b", .8), border = NA)
}
cx <- seq(xleft, xright, length.out = 160)
cy <- approx(c(xleft, 1.9, 3.1, 4.25, 5.55, xright),
             c(3.0, 3.25, 3.75, 4.0, 4.85, 6.15), xout = cx, method = "linear")$y
polygon(c(cx, rev(cx)), c(cy, rep(ybase, length(cy))),
        col = grDevices::adjustcolor("#e8ad4b", .12), border = NA)
lines(cx, cy, col = "#f7faf7", lwd = 3.2)
points(c(xleft, 3.1, 4.25, 5.55, xright), c(3, 3.75, 4, 4.85, 6.15),
       pch = 21, cex = 1.5, bg = "#f7faf7", col = "#10534f", lwd = 2)

# Points lumineux décoratifs et filet inférieur.
set.seed(24)
points(runif(36, .55, 8.5), runif(36, .7, 10.6), pch = 16,
       cex = runif(36, .3, .85), col = grDevices::adjustcolor("#f6e8c8", .68))
segments(.8, .65, 8.2, .65, col = grDevices::adjustcolor("#f7faf7", .3), lwd = 1.2)

par(op)
dev.off()
message("Couverture PNG créée : resources/images/couverture.png")
