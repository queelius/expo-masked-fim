<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1433768541170" ID="ID_1468916546" MODIFIED="1433771065318" TEXT="Research">
<node CREATED="1433768613954" ID="ID_1286271816" MODIFIED="1433768641043" POSITION="right" TEXT="Data">
<node CREATED="1433768625495" ID="ID_1392278440" MODIFIED="1433770488468" TEXT="Masked failure data">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      <font color="rgb(0, 0, 0)" face="Arial, Lucida Grande, Geneva, Verdana, Helvetica, Lucida Sans Unicode, sans-serif">Masked failure data: the cause of failure for the system is not known exactly; rather, some subset S, |S| &gt; 1, of the components in the system are known to be the cause. </font>
    </p>
    <p>
      
    </p>
    <p>
      <font color="rgb(0, 0, 0)" face="Arial, Lucida Grande, Geneva, Verdana, Helvetica, Lucida Sans Unicode, sans-serif">Note: Another name for components, in a competing-risks model, a component is just a potential risk.</font>
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1433768629238" ID="ID_1861277905" MODIFIED="1433770056581" TEXT="Left censored data"/>
<node CREATED="1433768643104" ID="ID_250335244" MODIFIED="1433770058586" TEXT="Right censored data">
<node CREATED="1433769870878" ID="ID_689869742" MODIFIED="1433769875785" TEXT="Suspension time"/>
</node>
<node CREATED="1433768653261" ID="ID_480894251" MODIFIED="1433773098737" TEXT="Interval time"/>
<node CREATED="1433768661103" ID="ID_975912818" MODIFIED="1433773103862" TEXT="Exact time (point)"/>
</node>
<node CREATED="1433769889109" ID="ID_1618920322" MODIFIED="1433769893084" POSITION="right" TEXT="MLE"/>
<node CREATED="1433770201509" ID="ID_1424037648" MODIFIED="1433770210774" POSITION="left" TEXT="Systems">
<node CREATED="1433770211468" ID="ID_300271844" MODIFIED="1433770644147" TEXT="Parallel systems"/>
<node CREATED="1433770215066" ID="ID_145523884" MODIFIED="1433770640900" TEXT="Series systems">
<node CREATED="1433770195919" ID="ID_58752443" MODIFIED="1433770199521" TEXT="Competing-risks model"/>
</node>
<node CREATED="1433770218436" ID="ID_1800998564" MODIFIED="1433770226979" TEXT="Complex systems"/>
</node>
<node CREATED="1433770615016" ID="ID_341293868" MODIFIED="1433770616516" POSITION="left" TEXT="Estimating Component Reliabilities from Incomplete System Failure Data">
<node CREATED="1433770666551" ID="ID_261130296" MODIFIED="1433772976020" TEXT="Estimating component reliabilities from masked system failure data"/>
<node CREATED="1433770657415" ID="ID_110582797" MODIFIED="1433770660725" TEXT="System failure data"/>
<node CREATED="1433772410614" ID="ID_1736296038" MODIFIED="1433772419631" TEXT="s-independent masking"/>
</node>
<node CREATED="1433771066256" ID="ID_820774502" MODIFIED="1433771070608" POSITION="left" TEXT="Reliability functions">
<node CREATED="1433770921089" ID="ID_1082515672" MODIFIED="1433771568961" TEXT="Survival function">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      S(t) = 1 - F(t) = Pr[T &gt; t]
    </p>
    <p>
      
    </p>
    <p>
      S(t) = exp{ -chf(t) }
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1433770908985" ID="ID_61178513" MODIFIED="1433771448889" TEXT="Hazard function">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      h(t) = lim dt -&gt; 0 { Pr[t &lt;= T &lt; t + dt|T &gt;= t] } / dt
    </p>
    <p>
      
    </p>
    <p>
      h(t) = 1 / [1 - F(t)] * lim dt -&gt; 0 { F(t + dt) - F(t) } / dt = 1 / S(t) * lim dt -&gt; 0 { S(t) - S(t + dt) } / dt = - d log S(t) / dt
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1433770932432" ID="ID_1960405258" MODIFIED="1433770935274" TEXT="pdf"/>
<node CREATED="1433770929235" ID="ID_1232997951" MODIFIED="1433770930630" TEXT="CDF"/>
<node CREATED="1433770950368" ID="ID_98125843" MODIFIED="1433771171045" TEXT="Cumulative hazard function">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      chf(t) = integrate h(s) ds from s = 0 to s = t
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node CREATED="1433772856406" ID="ID_1668460198" MODIFIED="1433772891491" POSITION="left" TEXT="possible direction 1">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Chapter 7 of the reliability book by Leemis for discussion on Likelihood Theory.
    </p>
  </body>
</html>
</richcontent>
<node CREATED="1433772769842" ID="ID_227542097" MODIFIED="1433772869698" TEXT="information matrix">
<node CREATED="1433772784116" ID="ID_756540934" MODIFIED="1433772915016" TEXT="observed information matrix">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      This is needed when you establish the asymptotic distribution of the MLE (not sure if this may be a direction that you will go in your masters project).
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1433772808803" ID="ID_1490856436" MODIFIED="1433772812657" TEXT="derivative of score vector"/>
</node>
<node CREATED="1433772776214" ID="ID_633150308" MODIFIED="1433772778898" TEXT="score vector"/>
</node>
</node>
</map>
