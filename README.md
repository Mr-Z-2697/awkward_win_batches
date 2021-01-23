# awkward_win_batches
much of them will be encoding-related

### For the convenience of myself. But I'll be glad if others find them useful.

## Tips
makeuci&makeheic: 
1. use crf 21 to get visually lossless.
2. default x265 parameters are designed for high quality (e.g. visually lossless), you might better use x265 preset for high compression uses.
3. use zscale version for rgb sources to get better conversion, use swscale version for yuv sources to handle (possible) odd-res yuv420.

makeavif:
1. for testing.
2. it's slower, and not better than x265. (you can tweak "cpu-used" to get speed of course)
3. suggestion: don't use it.
