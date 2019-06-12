* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* Trade additions by David Wogan, APERC - Jan 2019
*
* OSEMOSYS 2011.07.07
* Open Source energy Modeling SYStem
*
* ============================================================================
*
* #########################################
* ######################## Model Definition #############
* #########################################
*
* ##############
* # Sets #
* ##############
*
set YEAR;
set YEAR2(YEAR);
alias (y,yy,YEAR2);
set TECHNOLOGY;
alias (t,TECHNOLOGY);
set TIMESLICE;
alias (l,TIMESLICE);
set FUEL;
alias (f,FUEL);
set EMISSION;
alias (ghg,EMISSION);
set MODE_OF_OPERATION;
alias (m,MODE_OF_OPERATION);
set ECONOMY;
alias (r,rr,ECONOMY2,ECONOMY);
set BOUNDARY_INSTANCES;
alias (b,BOUNDARY_INSTANCES);
set STORAGE;
alias (s,STORAGE);
*
* ####################
* # Parameters #
* ####################
*
* ####### Global #############
*
parameter StartYear;
parameter YearSplit(TIMESLICE,YEAR);
parameter DiscountRate(ECONOMY,TECHNOLOGY);
parameter TradeRoute(ECONOMY,ECONOMY2,FUEL,YEAR);
*parameter TradeRoute(ECONOMY,ECONOMY2,FUEL,YEAR);
*
* ####### Demands #############
*
parameter SpecifiedAnnualDemand(ECONOMY,FUEL,YEAR);
parameter SpecifiedDemandProfile(ECONOMY,FUEL,TIMESLICE,YEAR);
parameter AccumulatedAnnualDemand(ECONOMY,FUEL,YEAR);
*
* ######## Technology #############
*
* ######## Performance #############
*
parameter CapacityToActivityUnit(ECONOMY,TECHNOLOGY);
parameter TechWithCapacityNeededToMeetPeakTS(ECONOMY,TECHNOLOGY);
parameter CapacityFactor(ECONOMY,TECHNOLOGY,YEAR);
parameter AvailabilityFactor(ECONOMY,TECHNOLOGY,YEAR);
parameter OperationalLife(ECONOMY,TECHNOLOGY);
parameter ResidualCapacity(ECONOMY,TECHNOLOGY,YEAR);
parameter SalvageFactor(ECONOMY,TECHNOLOGY,YEAR);
parameter InputActivityRatio(ECONOMY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
parameter OutputActivityRatio(ECONOMY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
*
* ######## Technology Costs #############
*
parameter CapitalCost(ECONOMY,TECHNOLOGY,YEAR);
parameter VariableCost(ECONOMY,TECHNOLOGY,MODE_OF_OPERATION,YEAR);
parameter FixedCost(ECONOMY,TECHNOLOGY,YEAR);
*
* ######## Storage Parameters #############
*
parameter StorageInflectionTimes(YEAR,TIMESLICE,BOUNDARY_INSTANCES);
parameter TechnologyToStorage(ECONOMY,TECHNOLOGY,STORAGE,MODE_OF_OPERATION);
parameter TechnologyFromStorage(ECONOMY,TECHNOLOGY,STORAGE,MODE_OF_OPERATION);
parameter StorageUpperLimit(ECONOMY,STORAGE);
parameter StorageLowerLimit(ECONOMY,STORAGE);
*
* ######## Capacity Constraints #############
*
parameter TotalAnnualMaxCapacity(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalAnnualMinCapacity(ECONOMY,TECHNOLOGY,YEAR);
*
* ######## Investment Constraints #############
*
parameter TotalAnnualMaxCapacityInvestment(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalAnnualMinCapacityInvestment(ECONOMY,TECHNOLOGY,YEAR);
*
* ######## Activity Constraints #############
*
parameter TotalTechnologyAnnualActivityUpperLimit(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalTechnologyAnnualActivityLowerLimit(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalTechnologyModelPeriodActivityUpperLimit(ECONOMY,TECHNOLOGY);
parameter TotalTechnologyModelPeriodActivityLowerLimit(ECONOMY,TECHNOLOGY);
*
* ######## Reserve Margin ############
*
parameter ReserveMarginTagTechnology(ECONOMY,TECHNOLOGY,YEAR);
parameter ReserveMarginTagFuel(ECONOMY,FUEL,YEAR);
parameter ReserveMargin(ECONOMY,YEAR);
*
* ######## RE Generation Target ############
*
parameter RETagTechnology(ECONOMY,TECHNOLOGY,YEAR);
parameter RETagFuel(ECONOMY,FUEL,YEAR);
parameter REMinProductionTarget(ECONOMY,YEAR);
*
* ######### Emissions & Penalties #############
*
parameter EmissionActivityRatio(ECONOMY,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR);
parameter EmissionsPenalty(ECONOMY,EMISSION,YEAR);
parameter AnnualExogenousEmission(ECONOMY,EMISSION,YEAR);
parameter AnnualEmissionLimit(ECONOMY,EMISSION,YEAR);
parameter ModelPeriodExogenousEmission(ECONOMY,EMISSION);
parameter ModelPeriodEmissionLimit(ECONOMY,EMISSION);
*
parameter YearVal(YEAR);
*
* #####################
* # Model Variables #
* #####################
*
* ############### Capacity Variables ############*
*
positive variable NewCapacity(YEAR2,TECHNOLOGY,ECONOMY);
positive variable AccumulatedNewCapacity(YEAR2,TECHNOLOGY,ECONOMY);
positive variable TotalCapacityAnnual(YEAR2,TECHNOLOGY,ECONOMY);
*
*############### Activity Variables #############
*
positive variable RateOfActivity(YEAR2,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY);
positive variable RateOfTotalActivity(YEAR2,TIMESLICE,TECHNOLOGY,ECONOMY);
positive variable TotalTechnologyAnnualActivity(YEAR2,TECHNOLOGY,ECONOMY);
positive variable TotalAnnualTechnologyActivityByMode(YEAR2,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY);
positive variable RateOfProductionByTechnologyByMode(YEAR2,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,ECONOMY);
positive variable RateOfProductionByTechnology(YEAR2,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable ProductionByTechnology(YEAR2,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable ProductionByTechnologyAnnual(YEAR2,TECHNOLOGY,FUEL,ECONOMY);
positive variable RateOfProduction(YEAR2,TIMESLICE,FUEL,ECONOMY);
positive variable Production(YEAR2,TIMESLICE,FUEL,ECONOMY);
positive variable RateOfUseByTechnologyByMode(YEAR2,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,ECONOMY);
positive variable RateOfUseByTechnology(YEAR2,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable UseByTechnologyAnnual(YEAR2,TECHNOLOGY,FUEL,ECONOMY);
positive variable RateOfUse(YEAR2,TIMESLICE,FUEL,ECONOMY);
positive variable UseByTechnology(YEAR2,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable Use(YEAR2,TIMESLICE,FUEL,ECONOMY);
*
positive variable ProductionAnnual(YEAR2,FUEL,ECONOMY);
positive variable UseAnnual(YEAR2,FUEL,ECONOMY);
*
positive variable RateOfDemand(YEAR2,TIMESLICE,FUEL,ECONOMY);
positive variable Demand(YEAR2,TIMESLICE,FUEL,ECONOMY);

* infeasible if declared as positive variable
variable Trade(ECONOMY,ECONOMY2,TIMESLICE,FUEL,YEAR2);
variable TradeAnnual(ECONOMY,ECONOMY2,FUEL,YEAR2);
*
*
* ############### Costing Variables #############
*
positive variable CapitalInvestment(YEAR2,TECHNOLOGY,ECONOMY);
positive variable DiscountedCapitalInvestment(YEAR2,TECHNOLOGY,ECONOMY);
*
positive variable SalvageValue(YEAR2,TECHNOLOGY,ECONOMY);
positive variable DiscountedSalvageValue(YEAR2,TECHNOLOGY,ECONOMY);
positive variable OperatingCost(YEAR2,TECHNOLOGY,ECONOMY);
positive variable DiscountedOperatingCost(YEAR2,TECHNOLOGY,ECONOMY);
*
positive variable AnnualVariableOperatingCost(YEAR2,TECHNOLOGY,ECONOMY);
positive variable AnnualFixedOperatingCost(YEAR2,TECHNOLOGY,ECONOMY);
positive variable VariableOperatingCost(YEAR2,TIMESLICE,TECHNOLOGY,ECONOMY);
*
positive variable TotalDiscountedCost(YEAR2,TECHNOLOGY,ECONOMY);
*
positive variable ModelPeriodCostByECONOMY (ECONOMY);
*
* ############### Storage Variables #############
*
free variable NetStorageCharge(STORAGE,YEAR2,TIMESLICE,ECONOMY);
free variable StorageLevel(STORAGE,BOUNDARY_INSTANCES,ECONOMY);
free variable StorageCharge(STORAGE,YEAR2,TIMESLICE,ECONOMY);
free variable StorageDischarge(STORAGE,YEAR2,TIMESLICE,ECONOMY);
*
* ######## Reserve Margin #############
*
positive variable TotalCapacityInReserveMargin(ECONOMY,YEAR2);
positive variable DemandNeedingReserveMargin(YEAR2,TIMESLICE,ECONOMY);
*
* ######## RE Gen Target #############
*
free variable TotalGenerationByRETechnologies(YEAR2,ECONOMY);
free variable TotalREProductionAnnual(YEAR2,ECONOMY);
free variable RETotalDemandOfTargetFuelAnnual(YEAR2,ECONOMY);
*
free variable TotalTechnologyModelPeriodActivity(TECHNOLOGY,ECONOMY);
*
* ######## Emissions #############
*
positive variable AnnualTechnologyEmissionByMode(YEAR2,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,ECONOMY);
positive variable AnnualTechnologyEmission(YEAR2,TECHNOLOGY,EMISSION,ECONOMY);
positive variable AnnualTechnologyEmissionPenaltyByEmission(YEAR2,TECHNOLOGY,EMISSION,ECONOMY);
positive variable AnnualTechnologyEmissionsPenalty(YEAR2,TECHNOLOGY,ECONOMY);
positive variable DiscountedTechnologyEmissionsPenalty(YEAR2,TECHNOLOGY,ECONOMY);
positive variable AnnualEmissions(YEAR2,EMISSION,ECONOMY);
free variable EmissionsProduction(YEAR2,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,ECONOMY);
positive variable ModelPeriodEmissions(EMISSION,ECONOMY);