using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class Coach {

    //data
    var data;

    var stepMax = 0;
    var stepSum = 0;
    var stepAvg;
    var distMax = 0;
    var distSum = 0;
    var distAvg;
    var calMax = 0;
    var calSum = 0;
    var calAvg;

    function initialize() {
        var history = ActivityMonitor.getHistory();
        data = new [8];

        var info = ActivityMonitor.getInfo();
        data[0] = [info.calories, info.steps, info.stepGoal, info.distance, Time.now()];
        for (var i = 0; i < history.size() && i <= 6; i++) {
            var item = history[i];
            data[i+1] = [item.calories, item.steps, item.stepGoal, item.distance/(100.0*1000), item.startOfDay];
            stepSum = stepSum + item.steps;
            calSum = calSum + item.calories;
            distSum = distSum + item.distance/(100.0*1000); // convert cm to m;
            if ( stepMax < item.steps ) {
                stepMax = item.steps;
            }
            if ( distMax < item.distance ) {
                distMax = item.distance/(100.0*1000); // convert cm to m;
            }
            if ( calMax < item.calories ) {
                calMax = item.calories;
            }
        }
        stepAvg = stepSum / history.size();
        distAvg = distSum / history.size();
        calAvg = calSum / history.size();
    }

    function getText() {
        var candidates = getCandidateTexts();

        var rnd = Math.rand().abs() % candidates.size();

        return candidates[rnd];
    }

    private function getCandidateTexts() {
        var texts = new [0];

        // streak!

        if ( above_average_calories( today() ) && above_average_calories( yesterday() ) ) {
            texts.add("Great workout the last two days!");
        }

        // simple above average

        if ( above_average_calories( today() ) ) {
            texts.add("Good job! Today you burned more than your weekly average of calories." + " " +  vcalories(today()) + " vs. " + calAvg);
        }
        if ( above_average_steps( today() ) ) {
            texts.add("Good job! Today you walked more steps than your weekly average." + " " +  vsteps(today()) + " vs. " + stepAvg);
        }
        if ( above_average_distance( today() ) ) {
            texts.add("Good job! Today you covered more distance than your weekly average." + " " +  vdistance(today()) + " vs. " + distAvg);
        }

        // can still make it?

        if ( below_average_calories( today() ) && hours_left_today(8) ) {
            texts.add("You should consider doing a workout this evening to reach your calorie average!" + " " +  vcalories(today()) + " vs. " + calAvg);
        }

        // sameday lastrweek simple comparisons

        if ( vcalories( today() ) < vcalories( samedaylastweek() ) ) {
            texts.add("Keep on it, you can still reach last weeks calorie value!" + " " + vcalories(today()) + " vs. " + vcalories(samedaylastweek()));
        }
        if ( vcalories( today() ) > vcalories( samedaylastweek() ) ) {
            texts.add("Congratulations, you beat last weeks calories value!" + " " +  vcalories(today()) + " vs. " + vcalories(samedaylastweek()));
        }
        if ( vsteps( today() ) < vsteps( samedaylastweek() ) ) {
            texts.add("Keep on it, you can still reach last weeks step count!" + " " +  vsteps(today()) + " vs. " + vsteps(samedaylastweek()));
        }
        if ( vsteps( today() ) > vsteps( samedaylastweek() ) ) {
            texts.add("Congratulations, you beat last weeks step count!" + " " +  vsteps(today()) + " vs. " + vsteps(samedaylastweek()));
        }
        if ( vdistance( today() ) < vdistance( samedaylastweek() ) ) {
            texts.add("Keep on it, you can still reach last weeks distance!" + " " +  vdistance(today()) + " vs. " + vdistance(samedaylastweek()));
        }
        if ( vdistance( today() ) > vdistance( samedaylastweek() ) ) {
            texts.add("Congratulations, you beat last weeks distance!" + " " +  vdistance(today()) + " vs. " + vdistance(samedaylastweek()));
        }
        return texts;
    }

    private function today() {
        return data[0];
    }

    private function yesterday() {
        return data[1];
    }

    private function samedaylastweek() {
        return data[7];
    }

    private function vcalories(day) {
        return day[0];
    }

    private function vsteps(day) {
        return day[1];
    }

    private function vstep_goal(day) {
        return day[2];
    }

    private function vdistance(day) {
        return day[3];
    }

    private function hours_left_today(hours) {
        //return Time.Gregorian.info(moment, Time.FORMAT_LONG).day_of_week.substring(0, 2);
        // day[4]
        return true;
    }

    private function above_average_calories(day) {
        return vcalories(day) > calAvg;
    }

    private function above_average_steps(day) {
        return vsteps(day) > stepAvg;
    }

    private function above_average_distance(day) {
        return vdistance(day) > distAvg;
    }

    private function below_average_calories(day) {
        return vcalories(day) < calAvg;
    }

}


