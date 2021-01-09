/**
 * @file
 * Implements ElliottWave strategy.
 */

// Includes EA31337 framework.
#include <EA31337-classes/EA.mqh>
#include <EA31337-classes/Indicator.mqh>
#include <EA31337-classes/Strategy.mqh>

// Includes local files.
#include "Indi_ElliottWave.mqh"

// Inputs.
input string __ElliottWave_Parameters__ = "-- ElliottWave strategy params --";  // >>> ELLIOTT WAVE <<<
input int Active_Tfs = 15;                // Activated timeframes (1-255) [M1=1,M5=2,M15=4,M30=8,H1=16,H4=32,H8=64...]
input ENUM_LOG_LEVEL Log_Level = V_INFO;  // Log level.
input bool Info_On_Chart = true;          // Display info on chart.

// Includes strategy.
#include "Stg_ElliottWave.mqh"

// Defines.
#define ea_name "Stg_ElliottWave"
#define ea_version "1.000"
#define ea_desc "Strategy based on EA31337 framework."
#define ea_link "https://github.com/EA31337/Strategy-ElliottWave"
#define ea_author "kenorb"

// Properties.
#property version ea_version
#ifdef __MQL4__
#property description ea_name
#property description ea_desc
#endif
#property link ea_link
#property copyright "Copyright 2016-2021, kenorb"

// Class variables.
EA *ea;

/* EA event handler functions */

/**
 * Implements "Init" event handler function.
 *
 * Invoked once on EA startup.
 */
int OnInit() {
  bool _result = true;
  EAParams ea_params(__FILE__, Log_Level);
  ea_params.SetChartInfoFreq(Info_On_Chart ? 2 : 0);
  ea = new EA(ea_params);
  _result &= ea.StrategyAdd<Stg_ElliottWave>(Active_Tfs);
  return (_result ? INIT_SUCCEEDED : INIT_FAILED);
}

/**
 * Implements "Tick" event handler function (EA only).
 *
 * Invoked when a new tick for a symbol is received, to the chart of which the Expert Advisor is attached.
 */
void OnTick() {
  ea.ProcessTick();
  if (!ea.Terminal().IsOptimization()) {
    ea.Log().Flush(2);
    ea.UpdateInfoOnChart();
  }
}

/**
 * Implements "Deinit" event handler function.
 *
 * Invoked once on EA exit.
 */
void OnDeinit(const int reason) { Object::Delete(ea); }
