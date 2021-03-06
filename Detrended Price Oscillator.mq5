//+------------------------------------------------------------------+
//|                                   Detrended Price Oscillator.mq5 |
//| 				                 Copyright © 2010-2020, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010-2020, EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/DetrendedPriceOscillator/"
#property version   "1.00"

#property description "Detrended Price Oscillator tries to capture the short-term trend"
#property description "changes. Indicator's cross with zero is the best indicator of such"
#property description "change."

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots 1
#property indicator_width1 1
#property indicator_color1 Blue
#property indicator_type1 DRAW_LINE
#property indicator_style1 STYLE_SOLID

input int MA_Period = 14;
input int BarsToCountInput = 400;

int BarsToCount;
int Shift;

// Buffers
double DPO[];
double MA[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
{
	IndicatorSetString(INDICATOR_SHORTNAME, "DPO(" + IntegerToString(MA_Period) + ")");
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);
   SetIndexBuffer(0, DPO, INDICATOR_DATA);
   BarsToCount = BarsToCountInput;
   Shift = MA_Period / 2 + 1;
}

//+------------------------------------------------------------------+
//| Detrended Price Oscillator                                       |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &Close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   // Too few bars to do anything
   if (rates_total <= MA_Period) return(0);
   // If we don't have enough bars to count as specified in the input
   if (BarsToCount >= rates_total) BarsToCount = rates_total;
   
   int myMA = iMA(NULL, 0, MA_Period, 0, MODE_SMA, PRICE_CLOSE);
   if  (CopyBuffer(myMA, 0, 0, rates_total, MA) != rates_total)
   {
      //Print("Error copying MA buffer.");
      return(0);
   }

   for (int i = rates_total - BarsToCount + MA_Period + 1; i < rates_total; i++)
   {
      DPO[i] = Close[i] - MA[i - Shift];
   }

   return(rates_total);
}
//+------------------------------------------------------------------+