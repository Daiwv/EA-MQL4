//+------------------------------------------------------------------+
//|                                                       Pardon.mq4 |
/*
 这是一个简化的方向指示指标
 */
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, 环球外汇网友交流群@Aother,448036253@qq.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   EventSetTimer(1);
   //创建对象
   ObjectCreate(0,"lblTimer",OBJ_LABEL,0,NULL,NULL);
   ObjectCreate(0,"lblTrend",OBJ_LABEL,0,NULL,NULL);
   ObjectCreate(0,"lblAuthor",OBJ_LABEL,0,NULL,NULL);
   ObjectCreate(0,"lblAdvice",OBJ_LABEL,0,NULL,NULL);
   //设置内容
   ObjectSetString(0,"lblTimer",OBJPROP_TEXT,_Symbol+"蜡烛剩余");
   ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"MACD判断");
   ObjectSetString(0,"lblAuthor",OBJPROP_TEXT,"作者：环球外汇网@Aother");
   ObjectSetString(0,"lblAdvice",OBJPROP_TEXT,"操作建议：待定");
   //设置颜色
   ObjectSetInteger(0,"lblTimer",OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,"lblTrend",OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_COLOR,clrGray);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_COLOR,clrRed);
   //--- 定位右上角 
   ObjectSetInteger(0,"lblTimer",OBJPROP_CORNER ,CORNER_RIGHT_UPPER); 
   ObjectSetInteger(0,"lblTrend",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   //--- 定位右下角
   ObjectSetInteger(0,"lblAdvice",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   //设置XY坐标
   ObjectSetInteger(0,"lblTimer",OBJPROP_XDISTANCE,200);   
   ObjectSetInteger(0,"lblTimer",OBJPROP_YDISTANCE,40);
   ObjectSetInteger(0,"lblTrend",OBJPROP_XDISTANCE,200);  
   ObjectSetInteger(0,"lblTrend",OBJPROP_YDISTANCE,60);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,"lblAuthor",OBJPROP_YDISTANCE,80);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_XDISTANCE,450);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_YDISTANCE,20);
   
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   
  
   
   ObjectsDeleteAll(0, 0, OBJ_LABEL);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // 趋势感知：上一个收盘价的指标
   //MACD主要，大周期
   double macdBigMain = iMACD(_Symbol,Period()*4,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   //MACD信号，大周期
   double macdBigSignal = iMACD(_Symbol,Period()*4,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);

   // 操作建议
   string advice = "";
   
  //MACD趋势：震荡调整
   if((macdBigSignal>0 && macdBigMain<0) || (macdBigSignal<0 && macdBigMain>0))
   {
      ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"大周期MACD：震荡调整~");
      advice = "操作建议：多空皆可，轻仓";
   }
   else if(macdBigSignal>0 && macdBigMain>0)
   {
      ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"大周期MACD：多头趋势↑");
      advice = "操作建议：只做多，抓住趋势的开始可重仓";
   }
   else if(macdBigSignal<0 && macdBigMain<0)
   {
      ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"大周期MACD：空头趋势↓");
      advice = "操作建议：只做空，抓住趋势的开始可重仓";
   }
   else
   {
      ObjectSetString(0,"lblTrend",OBJPROP_TEXT,"大周期MACD：暂无");
      advice = "操作建议：暂无";   
   }
   
   // 显示操作建议
   ObjectSetString(0,"lblAdvice",OBJPROP_TEXT,advice);
   ObjectSetInteger(0,"lblAdvice",OBJPROP_XDISTANCE,16*StringLen(advice) + 16); 
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   // 定时刷新计算当前蜡烛剩余时间
   long hour = Time[0] + 60 * Period() - TimeCurrent();
   long minute = (hour - hour % 60) / 60;
   long second = hour % 60;
   ObjectSetString(0,"lblTimer",OBJPROP_TEXT,StringFormat("%s蜡烛剩余：%d分%d秒",_Symbol,minute,second));
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   
}
//+------------------------------------------------------------------+