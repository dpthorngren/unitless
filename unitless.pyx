cdef class Unit_System:
    def __call__(self,target):
        if type(target) is not str:
            raise TypeError("Units must be described in strings.")
        if '_per_' in target:
            i = target.find('_per_')
            return self(target[:i])/self(target[i+5:])
        cdef double result = 1.0
        target = target.split('_')
        for unit in target:
            if unit[-1].isdigit():
                if unit[-2].isdigit():
                    raise NotImplementedError("One digit powers only. Sorry.")
                result *= self(unit[:-1]) ** int(unit[-1])
                continue
            if unit in self._members:
                result *= self.__getattribute__(unit)
                continue
            if unit.endswith('s') and unit[:-1] in self._members:
                result *= self.__getattribute__(unit[:-1])
                continue
            for prefix in self._prefixes:
                if unit.startswith(prefix):
                    result *= (self.__getattribute__(prefix) *
                               self.__getattribute__(unit[len(prefix):]))
                    break
            else:
                raise AttributeError("Unit \"%s\" not understood."%unit)
        return result

    def __getattr__(self,attribute):
        # Do not try to interpret private attributes
        if attribute.startswith('_') or attribute.endswith('_'):
            raise AttributeError
        return self(attribute)

    def __cinit__(Unit_System self,str units="SI"):
        if units == "SI":
            self._initializeUnits_(1.,1.,1.)
        elif units == "CGS":
            self._initializeUnits_(1000.,100.,1)
        else:
            raise AttributeError("System \"%s\" not recognized."%units)
        # List of attributes
        self._members = sorted([i for i in dir(self) if not i.startswith('_')],key=len,reverse=True)
        self._prefixes = ['yocto', 'zepto', 'atto', 'femto', 'pico', 'nano', 'micro', 'milli', 'centi', 'kilo', 'mega', 'giga', 'terra', 'peta', 'exa', 'zetta', 'yotta']

    def _initializeUnits_(self, float massScaling=1.,float lengthScaling=1.,
                          float timeScaling=1.):
        # Compute scaling factors
        cdef float forceScaling = massScaling * lengthScaling / timeScaling**2
        cdef float pressureScaling = forceScaling / lengthScaling**2
        cdef float energyScaling = lengthScaling * forceScaling
        cdef float powerScaling = energyScaling / timeScaling
        cdef float spEntropyScaling = energyScaling / massScaling

        # SI Prefixes
        self.yocto  = 1e-24
        self.zepto  = 1e-21
        self.atto   = 1e-18
        self.femto  = 1e-15
        self.pico   = 1e-12
        self.nano   = 1e-9
        self.micro  = 1e-6
        self.milli  = 1e-3
        self.centi  = 1e-2
        self.kilo   = 1e3
        self.mega   = 1e6
        self.giga   = 1e9
        self.terra  = 1e12
        self.peta   = 1e15
        self.exa    = 1e18
        self.zetta  = 1e21
        self.yotta  = 1e24

        # Masses (default kilograms)
        self.gram       = massScaling * .001
        self.pound      = massScaling * .453592
        self.mNeptune   = massScaling * 1.0241e26
        self.mJupiter   = massScaling * 1.89813e27
        self.mEarth     = massScaling * 5.97219e24
        self.mProton    = massScaling * 1.67262178e-27
        self.mUranus    = massScaling * 8.6103e25
        self.mSaturn    = massScaling * 5.68319e26

        # Distances (default meters)
        self.meter      = lengthScaling * 1.0
        self.mile       = lengthScaling * 1609.344
        self.au         = lengthScaling * 149597870700.
        self.rJupiter   = lengthScaling * 6.9911e7
        self.rNeptune   = lengthScaling * 2.4622e7
        self.rUranus    = lengthScaling * 2.5266e7
        self.rEarth     = lengthScaling * 0.6371e7
        self.rSaturn    = lengthScaling * 5.7316e7

        # Time (default seconds)
        self.year       = timeScaling * 31556952.
        self.second     = timeScaling * 1.0
        self.minute     = timeScaling * 60.0
        self.hour       = timeScaling * 3600.0
        self.day        = timeScaling * 86400.

        # Volume (default cubic meters)
        self.liter      = lengthScaling**3 * .001
        self.gallon     = lengthScaling**3 * .00378541

        # Force (default newtons)
        self.newton     = forceScaling * 1.0
        self.dyne       = forceScaling * 1e-5

        # Pressure (default pascals)
        self.pascal     = pressureScaling * 1.
        self.barye      = pressureScaling * .1
        self.bar        = pressureScaling * 1e5

        #Energy (default joules)
        self.joule      = energyScaling * 1.0
        self.erg        = energyScaling * 1e-7

        # Power (default watts)
        self.lSun       = powerScaling * 3.846e26

        # Specific entropy (default joules / kg K)
        self.kboltzPerBaryon    = spEntropyScaling * 8.3145e3
        self.kJperGramKelvin    = spEntropyScaling * 1e6

        # Constants (default SI)
        self.G                  = lengthScaling**3 * 6.67259e-11 / (massScaling * timeScaling**2)
        self.stefanBoltzmann    = powerScaling * 5.670367e-8 / lengthScaling**2
        self.boltzmann          = energyScaling * 1.38064852e-23
