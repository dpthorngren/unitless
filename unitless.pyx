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

    def __cinit__(Unit_System self):
        # Constants (in CGS)
        self.G = 6.67259e-8                  # Dyne cm^2 / g^2
        self.stefanBoltzmann = 5.6704e-5     # Erg / cm^2 s K^4
        self.boltzmann = 1.380648e-16        # Erg / K

        # SI Prefixes
        self.yocto = 1e-24
        self.zepto = 1e-21
        self.atto = 1e-18
        self.femto = 1e-15
        self.pico = 1e-12
        self.nano = 1e-9
        self.micro = 1e-6
        self.milli = 1e-3
        self.centi = 1e-2
        self.kilo = 1e3
        self.mega = 1e6
        self.giga = 1e9
        self.terra = 1e12
        self.peta = 1e15
        self.exa = 1e18
        self.zetta = 1e21
        self.yotta = 1e24

        # Masses (in grams)
        self.gram = 1.0
        self.mNeptune = 1.0241e29
        self.mJupiter = 1.89813e30
        self.mEarth = 5.97219e27
        self.mProton = 1.67262178e-24
        self.mUranus = 8.6103e28
        self.mSaturn = 5.68319e29

        # Distances (in centimeters)
        self.cm = 1.0
        self.meter = 100.0
        self.mile = 160934.0
        self.au = 1.496e13
        self.rJupiter = 6.9911e9
        self.rNeptune = 2.4622e9
        self.rUranus = 2.5266e9
        self.rEarth = 0.6371e9
        self.rSaturn = 5.7316e9

        # Volume (in ccm)
        self.liter = 1000.0

        # Power (in erg/s)
        self.lSun = 3.846e33

        # Force (in dyn)
        self.newton = 1e5
        self.dyne = 1.0

        # Current (in biot)
        self.ampere = 10

        #Energy (in erg)
        self.joule = 1e7
        self.erg = 1.0

        # Pressure (in Ba)
        self.barye = 1.0
        self.bar = 1e6
        self.pascal = 10.
        self.gigapascal = 1e10

        # Specific entropy (in erg / g K)
        self.kboltzPerBaryon = 8.3145e7
        self.kJperGramKelvin = 1e10

        # Time (in seconds)
        self.year = 3.1556952e7
        self.second = 1.0
        self.minute = 60.0
        self.hour = 3600.0

        # List of attributes
        self._members = sorted([i for i in dir(self) if not i.startswith('_')],key=len,reverse=True)
        self._prefixes = ['yocto', 'zepto', 'atto', 'femto', 'pico', 'nano', 'micro', 'milli', 'centi', 'kilo', 'mega', 'giga', 'terra', 'peta', 'exa', 'zetta', 'yotta']
