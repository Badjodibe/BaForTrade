//+------------------------------------------------------------------+
//|                                                 BA_Avalement.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   datetime time =  TimeCurrent();
   if(IsEnvelopingHour(time))
     {
      Print("It is envelopping time");
     }
   else
     {
      Print("Not envelopping time");
     }
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| BookEvent function                                               |
//+------------------------------------------------------------------+
void OnBookEvent(const string &symbol)
  {
//---
   
  }
//+------------------------------------------------------------------+

// Check for envelopping time
bool IsEnvelopingHour( datetime currentTime)
  {
   MqlDateTime dt;
   TimeToStruct(currentTime, dt);
   Print("Entrer");
   bool answer = false;
   if(Period() == PERIOD_H4)
     {
      // Obtenir l'heure de la dernière bougie H4
         datetime lastH4CloseTime = iTime(_Symbol, PERIOD_H4, 0);
         MqlDateTime lastH4CloseDt;
         TimeToStruct(lastH4CloseTime, lastH4CloseDt);
         if (dt.hour >= (lastH4CloseDt.hour - 1) && dt.hour < lastH4CloseDt.hour){
            answer = true;
         }
     }
     else
       {
        if(Period() == PERIOD_D1)
          {
               Print("Entrer dans d");
               if(dt.hour >= 19 && dt.hour <= 23){
                  answer = true;
               }
          }
          else
            {
             if(Period() == PERIOD_W1)
               {
                if(dt.day_of_week == 5 || (dt.day_of_week == 6 && dt.hour < 24)){
                  answer = true;
                }
               }
            }
       }
   return answer;
  }
  
