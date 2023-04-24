# calculate SUM
import numpy as np
from operator import itemgetter 
from shapely.geometry import Polygon 
#from alpha_shapes.alpha_shapes import Alpha_Shaper
import alphashape

class calcSUM():
    def __init__(self, vrp_file, alp):
        if vrp_file.endswith('vrp') == True:
            vrp_data = self.read_vrp(vrp_file)
            V1, V2, V3, V4 = self.find_loc(vrp_data)
            self.f_low, self.dB_low = self.Voice(vrp_data, V1, V2, direction='forward')
            self.f_loud, self.dB_loud = self.Voice(vrp_data, V2, V3, direction='backward')
            self.f_form, self.dB_form = self.Voice(vrp_data, V3, V4, direction='forward')
            
        if vrp_file.endswith('vph') == True:
            vph_data = self.read_vph(vrp_file)
            freqs, levels = vph_data[0, 1:], vph_data[1:, 0]
            tasks = vph_data[1:, 1:]
            postasks = np.argwhere(tasks > 0.)
            
            task_f = np.zeros(np.shape(postasks)[0])
            task_L = np.zeros(np.shape(postasks)[0])
            
            self.task_f, self.task_L = task_f, task_L
            for ii, pair in enumerate(postasks):
                task_f[ii] = freqs[pair[1]]
                task_L[ii] = levels[pair[0]]
            hull, self.f_low, self.dB_low = self.hull_vph(task_f, task_L, alp)
            self.f_loud, self.dB_loud = [], []
            self.f_form, self.dB_form = [], []
            self.V = 8
            
        self.calcsum()

    def hull_vph(self, task_f, task_L, alp):
        
        corners = list(zip(task_f, task_L))
#        shaper = Alpha_Shaper(corners)
#        print(task_L)        
#        alpha_opt, alpha_shape = shaper.optimize()

#        print(1000.*alpha_opt)
#        hull = alphashape.alphashape(corners, 1/(1000.*alpha_opt))
        hull = alphashape.alphashape(corners, 1/alp)
        if hull.geom_type == 'MultiPolygon':
            for ii_multipoly in range(len(list(hull.geoms))):
                if ii_multipoly == 0:
                    hull_pts = np.asarray(hull.geoms[ii_multipoly].exterior.coords)
                elif ii_multipoly > 0:
                    hull_pts = np.append(hull_pts, np.asarray(hull.geoms[ii_multipoly].exterior.coords), axis=0)
        elif hull.geom_type == 'Polygon':
            hull_pts = np.asarray(hull.exterior.coords)     
        return hull, hull_pts[:, 0], hull_pts[:, 1]
        
    def read_vrp(self, vrp_file):
        vrp = open(vrp_file, "r")
        vrp_data = vrp.read()
        vrp.close()
#        os.remove(vrps)        
        return vrp_data
        
    def read_vph(self, vrp_file):
        with open (vrp_file, 'r') as vphfile:
            for line in vphfile:
                if line.startswith('#'):
                    if 'occ' in locals():
                        break
                else:
                    occ = 1
                    strlist = line.replace('\t', ' ').replace('\n', '').strip().split(' ')
                    floatlist = [float(x) for x in strlist]
                    if 'vph_data' not in locals():
                        vph_data = np.array(floatlist)
                    else:
                        vph_data = np.vstack((vph_data, floatlist))
        return vph_data
                        
        
    def find_loc(self, vrp_data):
        V1 = vrp_data.find('V')
        V2 = vrp_data.find('V', V1+1)
        V3 = vrp_data.find('V', V2+1)
        V4 = vrp_data.find('V', V3+1)
        self.V = vrp_data.count('V')
        return V1, V2, V3, V4
        
    def Voice(self, vrp_data, Vstart, Vend, direction):
        data = vrp_data[Vstart+2:Vend-1].replace('\r\n', '')
        data = data.split(':')
        dB = data[1::6]
        freq = data[2::6]
        freq = [float(i) for i in freq]
        dB = [float(i) for i in dB]
        
        if direction == 'forward':
            freq_sort = np.argsort(freq)
        elif direction == 'backward':
            freq_sort = np.argsort(freq)[::-1]
        freq = itemgetter(*freq_sort)(freq)
        dB = itemgetter(*freq_sort)(dB)   
        return np.array(freq), np.array(dB)      

    def calcsum(self):
        f = np.append(self.f_low, self.f_loud)
        self.dB = [float(i) for i in np.append(self.dB_low, self.dB_loud)]
        self.HT = np.round(np.log2(f/16.)*12, 2)
        corners = list(zip(self.HT, self.dB))
        self.asf = np.round(Polygon(corners).area, 2)
        self.usf = np.round(Polygon(corners).length, 2)
        self.SUM = np.round(50*np.log((self.asf*2.*np.pi*np.sqrt(self.asf/np.pi))/self.usf)-200., 2)

#cs = calcSUM('../test.vph', 100)
#cs = calcSUM('../test.vrp', .1)
#print(cs.SUM)
