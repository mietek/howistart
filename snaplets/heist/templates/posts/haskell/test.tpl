<apply template="base">
    <div class="container">

<p>Here's what a delimited code block looks like:</p>
<pre><code>~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.haskell}
-- | Inefficient quicksort in haskell.
qsort :: (Enum a) =&gt; [a] -&gt; [a]
qsort []     = []
qsort (x:xs) = qsort (filter (&lt; x) xs) ++ [x] ++
               qsort (filter (&gt;= x) xs)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</code></pre>
<p>And here's how it looks after syntax highlighting:</p>
<pre class="sourceCode haskell"><code class="sourceCode haskell"><span class="co">-- | Inefficient quicksort in haskell.</span>
<span class="ot">qsort ::</span> (<span class="dt">Enum</span> a) <span class="ot">=&gt;</span> [a] <span class="ot">-&gt;</span> [a]
qsort []     <span class="fu">=</span> []
qsort (x<span class="fu">:</span>xs) <span class="fu">=</span> qsort (filter (<span class="fu">&lt;</span> x) xs) <span class="fu">++</span> [x] <span class="fu">++</span>
               qsort (filter (<span class="fu">&gt;=</span> x) xs) </code></pre>
<p>Here's some python, with numbered lines (specify <code>{.python .numberLines}</code>):</p>
<table class="sourceCode python numberLines"><tr class="sourceCode"><td class="lineNumbers"><pre>1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
</pre></td><td class="sourceCode"><pre><code class="sourceCode python"><span class="kw">class</span> FSM(<span class="dt">object</span>):

<span class="co">&quot;&quot;&quot;This is a Finite State Machine (FSM).</span>
<span class="co">&quot;&quot;&quot;</span>

<span class="kw">def</span> <span class="ot">__init__</span>(<span class="ot">self</span>, initial_state, memory=<span class="ot">None</span>):

    <span class="co">&quot;&quot;&quot;This creates the FSM. You set the initial state here. The &quot;memory&quot;</span>
<span class="co">    attribute is any object that you want to pass along to the action</span>
<span class="co">    functions. It is not used by the FSM. For parsing you would typically</span>
<span class="co">    pass a list to be used as a stack. &quot;&quot;&quot;</span>

    <span class="co"># Map (input_symbol, current_state) --&gt; (action, next_state).</span>
    <span class="ot">self</span>.state_transitions = {}
    <span class="co"># Map (current_state) --&gt; (action, next_state).</span>
    <span class="ot">self</span>.state_transitions_any = {}
    <span class="ot">self</span>.default_transition = <span class="ot">None</span>
    ...</code></pre></td></tr></table>

    </div>
    </apply>
