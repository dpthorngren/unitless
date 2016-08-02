class Unit_System:
    def __call__(self,target):
        if type(target) is not str:
            raise TypeError("Units must be described in strings.")
        if '_per_' in target:
            i = target.find('_per_')
            return self(target[:i])/self(target[i+5:])
        result = 1.0
        target = target.split('_')
        for unit in target:
            if unit[-1].isdigit():
                if unit[-2].isdigit():
                    raise NotImplementedError("One digit powers only. Sorry.")
                result *= self(unit[:-1]) ** int(unit[-1])
                continue
            if unit in self.units:
                result *= self.units[unit]
                continue
            if unit.endswith('s') and unit[:-1] in self.units:
                result *= self.units[unit[:-1]]
                continue
            for prefix in self.prefixes.keys():
                if unit.startswith(prefix):
                    result *= (self.prefixes[prefix] * self(unit[len(prefix):]))
                    break
            else:
                raise AttributeError("Unit \"%s\" not understood."%unit)
        return result

    def __getattr__(self,attribute):
        # Do not try to interpret private attributes
        return self(attribute)

    def __init__(self,units="SI"):
        if units == "SI":
            self.initializeUnits(1.,1.,1.)
        elif units == "CGS":
            self.initializeUnits(1000.,100.,1)
        else:
            raise AttributeError("System \"%s\" not recognized."%units)

    def initializeUnits(self, massScaling=1., lengthScaling=1.,
                          timeScaling=1.):
        # Compute scaling factors
        forceScaling = massScaling * lengthScaling / timeScaling**2
        pressureScaling = forceScaling / lengthScaling**2
        energyScaling = lengthScaling * forceScaling
        powerScaling = energyScaling / timeScaling
        spEntropyScaling = energyScaling / massScaling
        self.prefixes = {}
        self.units={}

        # SI Prefixes
        self.prefixes['yocto']  = 1e-24
        self.prefixes['zepto']  = 1e-21
        self.prefixes['atto']   = 1e-18
        self.prefixes['femto']  = 1e-15
        self.prefixes['pico']   = 1e-12
        self.prefixes['nano']   = 1e-9
        self.prefixes['micro']  = 1e-6
        self.prefixes['milli']  = 1e-3
        self.prefixes['centi']  = 1e-2
        self.prefixes['kilo']   = 1e3
        self.prefixes['mega']   = 1e6
        self.prefixes['giga']   = 1e9
        self.prefixes['terra']  = 1e12
        self.prefixes['peta']   = 1e15
        self.prefixes['exa']    = 1e18
        self.prefixes['zetta']  = 1e21
        self.prefixes['yotta']  = 1e24

        # Masses (default kilograms)
        self.units['gram']       = massScaling * .001
        self.units['pound']      = massScaling * .453592
        self.units['ounce']      = massScaling * .0283495
        self.units['mJupiter']   = massScaling * 1.89813e27
        self.units['mSaturn']    = massScaling * 5.68319e26
        self.units['mNeptune']   = massScaling * 1.0241e26
        self.units['mUranus']    = massScaling * 8.6103e25
        self.units['mEarth']     = massScaling * 5.97219e24
        self.units['mProton']    = massScaling * 1.67262178e-27

        # Distances (default meters)
        self.units['meter']      = lengthScaling * 1.0
        self.units['mile']       = lengthScaling * 1609.344
        self.units['inch']       = lengthScaling * .0254
        self.units['yard']       = lengthScaling * .9144
        self.units['foot']       = lengthScaling * .3048
        self.units['feet']       = lengthScaling * .3048
        self.units['au']         = lengthScaling * 149597870700.
        self.units['angstrom']   = lengthScaling * 1e-10
        self.units['lightyear']  = lengthScaling * 9.4607304725808e15
        self.units['parsec']     = lengthScaling * 3.085677581491e16
        self.units['rJupiter']   = lengthScaling * 6.9911e7
        self.units['rSaturn']    = lengthScaling * 5.7316e7
        self.units['rNeptune']   = lengthScaling * 2.4622e7
        self.units['rUranus']    = lengthScaling * 2.5266e7
        self.units['rEarth']     = lengthScaling * 0.6371e7
        self.units['rBohr']      = lengthScaling * 5.2917721067e-11

        # Speed
        self.units['knot']       = lengthScaling/timeScaling * 1852.
        self.units['lightSpeed'] = lengthScaling/timeScaling * 299792458.0

        # Time (default seconds)
        self.units['year']       = timeScaling * 31556952.
        self.units['second']     = timeScaling * 1.0
        self.units['minute']     = timeScaling * 60.0
        self.units['hour']       = timeScaling * 3600.0
        self.units['day']        = timeScaling * 86400.

        # Volume (default cubic meters)
        self.units['liter']      = lengthScaling**3 * .001
        self.units['gallon']     = lengthScaling**3 * .00378541

        # Force (default newtons)
        self.units['newton']     = forceScaling * 1.0
        self.units['dyne']       = forceScaling * 1e-5

        # Pressure (default pascals)
        self.units['pascal']     = pressureScaling * 1.
        self.units['barye']      = pressureScaling * .1
        self.units['bar']        = pressureScaling * 1e5

        # Angle (radians)
        self.units['degree']     = 1.7453292519943e-2
        self.units['radian']     = 1.0
        self.units['arcmin']     = 2.9088820866572e-4
        self.units['arcsec']     = 4.8481368110954e-6

        # Energy (default joules)
        self.units['joule']      = energyScaling * 1.0
        self.units['erg']        = energyScaling * 1e-7
        self.units['eV']         = energyScaling * 1.60218e-19

        # Power (default watts)
        self.units['lSun']       = powerScaling * 3.828e26

        # Specific entropy (default joules / kg K)
        self.units['kboltzPerBaryon']    = spEntropyScaling * 8.3145e3
        self.units['kJperGramKelvin']    = spEntropyScaling * 1e6

        # Constants (default SI)
        self.units['G']                  = lengthScaling**3 * 6.67259e-11 / (massScaling * timeScaling**2)
        self.units['stefanBoltzmann']    = powerScaling * 5.670367e-8 / lengthScaling**2
        self.units['boltzmann']          = energyScaling * 1.38064852e-23
        self.units['gasConstant']        = energyScaling * 8.3144598

    def fahrenheitToCelsius(self,x):
        return (x-32.)*5./9.

    def celsiusToFahrenheit(self,x):
        return x*9./5. + 32.

    def celsiusToKelvin(self,x):
        return x + 273.15

    def kelvinToCelsius(self,x):
        return x - 273.15

    def fahrenheitToKelvin(self,x):
        return (x-32.)*5./9. + 273.15

    def kelvinToFahrenheit(self,x):
        return (x-273.15)*9./5. + 32.
