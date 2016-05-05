cdef class Unit_System:
    cdef:
        object members
        readonly double yocto
        readonly double zepto
        readonly double atto
        readonly double femto
        readonly double pico
        readonly double nano
        readonly double micro
        readonly double milli
        readonly double centi
        readonly double kilo
        readonly double mega
        readonly double giga
        readonly double terra
        readonly double peta
        readonly double exa
        readonly double zetta
        readonly double yotta

        readonly double G
        readonly double stefanBoltzmann
        readonly double boltzmann
        readonly double gram
        readonly double mNeptune
        readonly double mJupiter
        readonly double mUranus
        readonly double mEarth
        readonly double mSaturn
        readonly double mProton
        readonly double cm
        readonly double meter
        readonly double mile
        readonly double au
        readonly double rJupiter
        readonly double rUranus
        readonly double rNeptune
        readonly double rEarth
        readonly double rSaturn
        readonly double ml
        readonly double liter
        readonly double lSun
        readonly double newton
        readonly double dyne
        readonly double ampere
        readonly double joule
        readonly double erg
        readonly double barye
        readonly double bar
        readonly double pascal
        readonly double gigapascal
        readonly double kboltzPerBaryon
        readonly double kJperGramKelvin
        readonly double year
        readonly double second
        readonly double minute
        readonly double hour
