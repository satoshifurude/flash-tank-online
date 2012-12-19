<html>
<header>
rank
</header>
<body>
     <?php?>
         <form method = "post" action = "rate">
            <input type=submit value="rank all"/>
          </form>

         <form method="post" action="month">
             <label>Rank of Month</label>  </br>
             <label>Date</label>
             <input type="date" name="date" size="30" /><br />
             <input type=submit value="rank"/>
         </form>

        <form method="post" action="year">
              <label>Rank of Year</label>  </br>
              <label>Year</label>
              <input type="num" name="date" size="30" /><br />
              <input type=submit value="rank"/>
          </form>

</body>
</html>