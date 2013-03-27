import matplotlib
import matplotlib.pyplot as plt
from matplotlib.image import AxesImage

import numpy as np

#  assuming the following layout
#   <--  y  -->     <--  z  -->
# ^ +---------+   ^ +---------+
# | |         |   | |         |
#   |         |     |         |
# x |         |   x |         |
#   |         |     |         |
# | |         |   | |         |
# v +---------+   v +---------+
#
#                   <--  z  -->
#                 ^ +---------+
#                 | |         |
#                   |         |
#                 y |         |
#                   |         |
#                 | |         |
#                 v +---------+
#

class OrthoSlicer3D(object):
    """Orthogonal-plane slicer.

    OrthoSlicer3d expects 3-dimensional data, and creates a figure with 3
    axes for each slice orientation. Moving the mouse in any one axes will
    select out the corresponding slices in the other two. Clicking the right
    mouse button toggles mouse following and triggers a full redraw (to update
    the ticks, for example). Scrolling up and down moves that slice up and
    down. 

    Example
    -------
    import numpy as np
    a = np.sin(np.linspace(0,np.pi,20))
    b = np.sin(np.linspace(0,np.pi*5,20))
    data = np.outer(a,b)[..., np.newaxis]*a

    OrthoSlicer3D(data)

    """
    def __init__(self, data, axes=None, aspect_ratio=np.array((1,1,1))):
        """
        Parameters
        ----------
        data : ndarray (3d)
            The data that will be displaced by the slicer
        axes : mpl.Axes (3)
            3 axes instances for the Z, Y, and X slices, or None (default)
        aspect_ratio : ndarray (length 3)
            stretch factors for X,Y,Z directions (default: 1,1,1)
        """
        if axes is None:
            fig = plt.figure()
            x,y,z = data.shape  * aspect_ratio

            maxw = float(z+y)
            maxh = float(y+x)
            zw = y / maxw
            zh = x / maxh
            yw = z / maxw

            ax1 = fig.add_axes((0,  1.0-zh, zw,     zh))
            ax2 = fig.add_axes((zw, 1.0-zh, yw,     zh))
            ax3 = fig.add_axes((zw, 0.0   , yw, 1.0-zh))
            axes = (ax1, ax2, ax3)
        else:
            ax1, ax2, ax3 = axes

        self.data = data

        kw = dict(vmin=data.min(), vmax=data.max(), picker=True,
                aspect='auto')
        im1 = ax1.imshow(data[...,0], **kw)
        im2 = ax2.imshow(data[:,0,:], **kw)
        im3 = ax3.imshow(data[0,...], **kw)

        # idx will be used to slice in to the data with the appropriate
        # slicing scheme
        im1.idx = im2.idx = im3.idx = 0

        # set the maximum dimensions for i%dim indexing
        im1.size = data.shape[-1]
        im2.size = data.shape[-2]
        im3.size = data.shape[-3]

        im1.get_slice = lambda i: (slice(None), slice(None), i)
        im2.get_slice = lambda i: (slice(None), i, slice(None))
        im3.get_slice = lambda i: (i, slice(None), slice(None))

        # setup pairwise connections between the slice dimensions
        im1.imx = im2
        im1.imy = im3
        im2.imx = im1
        im2.imy = im3
        im3.imx = im1
        im3.imy = im2

        self.toggle_update = True
        self.figs = set([ax.figure for ax in axes])
        for fig in self.figs:
            fig.canvas.mpl_connect('pick_event', self.on_pick)
            fig.canvas.mpl_connect('motion_notify_event', self.on_pick)
        plt.show()


    def on_pick(self, event):
        # Here we do a bit of a hack to make mousemovement events fit the mold
        # of a pick event
        if hasattr(event,'inaxes') and event.inaxes:
            artist = event.inaxes.images[0]
            me = event
            me.button = 1 if self.toggle_update else 0
        elif hasattr(event, 'artist'):
            artist = event.artist
            me = event.mouseevent
        else:
            return
        if isinstance(artist, AxesImage):
            im = artist
            ax = artist.axes
            imx,imy = im.imx, im.imy
            if me.button == 1: # or self.toggle_update:
                #if me.button == 1:
                #    self.toggle_update = not self.toggle_update
                x,y = np.round((me.xdata, me.ydata)).astype(int)
                imx.set_data(self.data[imx.get_slice(x)])
                imy.set_data(self.data[imy.get_slice(y)])
                imx.idx = x
                imy.idx = y
                for i in imx, imy:
                    ax = i.axes
                    ax.draw_artist(i)
                    ax.figure.canvas.blit(ax.bbox)
                return
            if me.button == 3:
                self.toggle_update = not self.toggle_update
                # the axes might be in different figures, redraw all of them
                #for fig in self.figs:
                #    fig.canvas.draw() # redraw the ticks which don't get blitted
                plt.draw()
                return
            if me.button not in ('up', 'down'):
                return
            if me.button == 'up':
                im.idx += 1
            elif me.button == 'down':
                im.idx -= 1
            im.idx %= im.size
            im.set_data(self.data[im.get_slice(im.idx)])
            ax.draw_artist(im)
            ax.figure.canvas.blit(ax.bbox)

if __name__ == '__main__':
    import numpy as np
    a = np.sin(np.linspace(0,np.pi,20))
    b = np.sin(np.linspace(0,np.pi*5,20))
    data = np.outer(a,b)[..., np.newaxis]*a
    # all slices
    OrthoSlicer3D(data)

    # broken out into three separate figures
    f, ax1 = plt.subplots()
    f, ax2 = plt.subplots()
    f, ax3 = plt.subplots()
    OrthoSlicer3D(data, axes=(ax1, ax2, ax3))

