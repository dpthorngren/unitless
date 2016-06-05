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
        forceScaling = massScaling * lengthScaling / timeScaling**2
        pressureScaling = forceScaling / lengthScaling**2
        energyScaling = lengthScaling * forceScaling
        powerScaling = energyScaling / timeScaling
        spEntropyScaling = energyScaling / massScaling

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
        self.mile       = lengthScaling * 1609.34
        self.au         = lengthScaling * 1.496e11
        self.rJupiter   = lengthScaling * 6.9911e7
        self.rNeptune   = lengthScaling * 2.4622e7
        self.rUranus    = lengthScaling * 2.5266e7
        self.rEarth     = lengthScaling * 0.6371e7
        self.rSaturn    = lengthScaling * 5.7316e7

        # Time (default seconds)
        self.year       = timeScaling * 3.1556952e7
        self.second     = timeScaling * 1.0
        self.minute     = timeScaling * 60.0
        self.hour       = timeScaling * 3600.0

        # Volume (default cubic meters)
        self.liter      = lengthScaling**3 * .001
        self.gallon     = lengthScaling**3 * .00378541

        # Force (in dyn)
        self.newton     = forceScaling * 1.0
        self.dyne       = forceScaling * 1e-5

        # Pressure (in Ba)
        self.pascal     = pressureScaling * 1.
        self.barye      = pressureScaling * .1
        self.bar        = pressureScaling * 1e5

        #Energy (in erg)
        self.joule      = energyScaling * 1.0
        self.erg        = energyScaling * 1e-7

        # Power (in erg/s)
        self.lSun       = powerScaling * 3.846e26

        # Specific entropy (in erg / g K)
        self.kboltzPerBaryon    = spEntropyScaling * 8.3145e-3
        self.kJperGramKelvin    = spEntropyScaling * 1

        # Constants (in CGS)
        self.G                  = energyScaling * lengthScaling**2 * 6.67259e-8 / massScaling**2
        self.stefanBoltzmann    = energyScaling * 5.6704e-5 / (lengthScaling**2 * timeScaling)
        self.boltzmann          = energyScaling * 1.380648e-16
