using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class Coach {

    const IDX_CAL = 0;
    const IDX_STEP = 1;
    const IDX_STEPG = 2;
    const IDX_DIST = 3;
    const IDX_DAY = 4;

    //data
    var data;
    var average;
    var deviation;
    var min;
    var max;
    var today;
    var yesterday;
    var daybeforeyesterday;
    var samedaylastweek;

    var stepSum = 0;
    var distSum = 0;
    var calSum = 0;

    function initialize(vToday, vData) {
        max = [0, 0, 0, 0, 24];
        min = [99999, 99999, 99999, 99999, 24];
        today = vToday;
        data = vData;

        for (var i = 0; i < data.size(); i++) {
            var item = data[i];
            stepSum = stepSum + item[IDX_STEP];
            calSum = calSum + item[IDX_CAL];
            distSum = distSum + item[IDX_DIST];
            if ( max[IDX_STEP] < item[IDX_STEP] ) {
                max[IDX_STEP] = item[IDX_STEP];
            }
            if ( max[IDX_DIST] < item[IDX_DIST] ) {
                max[IDX_DIST] = item[IDX_DIST];
            }
            if ( max[IDX_CAL] < item[IDX_CAL] ) {
                max[IDX_CAL] = item[IDX_CAL];
            }
            if ( min[IDX_STEP] > item[IDX_STEP] ) {
                min[IDX_STEP] = item[IDX_STEP];
            }
            if ( min[IDX_DIST] > item[IDX_DIST] ) {
                min[IDX_DIST] = item[IDX_DIST];
            }
            if ( min[IDX_CAL] > item[IDX_CAL] ) {
                min[IDX_CAL] = item[IDX_CAL];
            }
        }
        yesterday = data[0];
        daybeforeyesterday = data[1];
        samedaylastweek = data[6];
        average = [calSum / data.size(), stepSum / data.size(), 0, distSum / data.size(), 24];

        deviation = [0, 0, 0, 0, 24];
        for (var i = 0; i < data.size(); i++) {
            deviation[IDX_CAL] = deviation[IDX_CAL] + (data[i][IDX_CAL] - average[IDX_CAL]) * (data[i][IDX_CAL] - average[IDX_CAL]);
            deviation[IDX_STEP] = deviation[IDX_STEP] + (data[i][IDX_STEP] - average[IDX_STEP]) * (data[i][IDX_STEP] - average[IDX_STEP]);
            deviation[IDX_DIST] = deviation[IDX_DIST] + (data[i][IDX_DIST] - average[IDX_DIST]) * (data[i][IDX_DIST] - average[IDX_DIST]);
        }
        deviation[IDX_CAL] = (Math.sqrt( deviation[IDX_CAL] / data.size() )) / average[IDX_CAL];
        deviation[IDX_STEP] = (Math.sqrt( deviation[IDX_STEP] / data.size() )) / average[IDX_STEP];
        deviation[IDX_DIST] = (Math.sqrt( deviation[IDX_DIST] / data.size() )) / average[IDX_DIST];

    }

    function getText() {
        var candidates = getCandidateTexts();

        var rnd = Math.rand().abs() % candidates.size();
        return candidates[rnd] + " ("+ rnd +"/"+ candidates.size() +")";
    }

    private function getCandidateTexts() {
        var texts = new [0];

        if ( current_hour() <= 10 ) {
            /////////////////////////////////////////////
            //   morning texts
            /////////////////////////////////////////////
            if ( (vcalories(today) > vcalories( average ) ) && (vcalories(yesterday) > vcalories( average ))  && ( current_hour() <= 10 ) ) {
                texts.add("Great workout the last two days! What is it going to be today?");
            }
            if ( ( vcalories(daybeforeyesterday) > vcalories(average) ) && ( vcalories(yesterday) > vcalories(average) ) && ( current_hour() <= 18 ) ) {
                texts.add("You were very active yesterday and the day before yesterday. Maybe you should rest a bit today?");
            }
            if ( vcalories( today ) < vcalories( min ) ) {
                if ( vcalories( yesterday ) > vcalories( average ) ) {
                    if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) < vcalories( min ) ) {
                        texts.add("You were quite active yesterday, so there is nothing wrong with going a bit more slowly today." + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( min ) );
                    }
                }
                else {
                    if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) - vcalories( min ) ) < -300 ) {
                        texts.add("You should plan a workout of 300kCal or more to reach your minimum today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( min ) );
                    }
                    if ( vcalories( daybeforeyesterday ) < vcalories( average ) ) {
                        if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) < vcalories( average ) ) {
                            texts.add("Yesterday and the day before yesterday you were not so active. How about working out today?" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                        }
                    }
                }
            } else if ( vcalories( today ) < vcalories( average ) ) {
                if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) > vcalories( average ) ) {
                    texts.add("It is pretty likely that you will be to consuming more calories today than your average!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                }
                if ( ( vcalories( today ) + remaining_calories_estimate_based_on( average ) - vcalories( average ) ) > 0 ) {
                    texts.add("If you remain as active as your average for the rest of the day, you are going to consume more calories than your average!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                }
            }

        }
        else if ( current_hour() < 18 ) {
            /////////////////////////////////////////////
            //   mid-day texts
            /////////////////////////////////////////////
            if ( ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) ) < vcalories( min )*0.9 ) {
                texts.add("Compared to your regular activity, you are not so active today..." + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( min ) );
                //texts.add("Change your life today. Don't gamble on the future, act now, without delay. - Simone de Beauvoir");
            }
            //if ( ( vcalories( today ) + remaining_calories_estimate_based_on( average ) ) < vcalories( average )*0.9 ) {
            //    texts.add("Compared to the average of the week, you are not so active today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( average ) + " vs. " + vcalories( average ) );
            //}
            if ( vcalories( today ) < vcalories( min ) ) {
                if ( vcalories( yesterday ) > vcalories( average ) ) {
                    if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) < vcalories( min ) ) {
                        texts.add("You were quite active yesterday, so there is nothing wrong with going a bit more slowly today." + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( min ) );
                    }
                }
                else {
                    if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) - vcalories( min ) ) < -300 ) {
                        texts.add("You should plan a workout of 300kCal or more to reach your minimum today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( min ) );
                    }
                    if ( vcalories( daybeforeyesterday ) < vcalories( average ) ) {
                        if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) < vcalories( average ) ) {
                            texts.add("Yesterday and the day before yesterday you were not so active. How about working out today?" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                        }
                    }
                }
            } else if ( vcalories( today ) < vcalories( average ) ) {
                if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) > vcalories( average ) ) {
                    texts.add("It is pretty likely that you will be to consuming more calories today than your average!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                }
                if ( ( vcalories( today ) + remaining_calories_estimate_based_on( average ) - vcalories( average ) ) > 0 ) {
                    texts.add("If you remain as active as your average for the rest of the day, you are going to consume more calories than your average!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                }
                if ( vcalories( yesterday ) > vcalories( average ) ) {
                    if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) < vcalories( average ) ) {
                        texts.add("You were quite active yesterday. Maintain a regular level of activity today to give your body time to recover." + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                    }
                }
                else {
                    if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) < vcalories( average ) ) {
                        texts.add("It is pretty unlikely that you are going to reach the average today. You should work out if possible!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                    }
                    if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) - vcalories( average ) ) < -300 ) {
                        texts.add("If you would do a workout of 300kCal or more today, you could your average!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                    }
                    if ( vcalories( daybeforeyesterday ) < vcalories( average ) ) {
                        if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) < vcalories( average ) ) {
                            texts.add("Yesterday and the day before yesterday you were not so active. How about working out today?" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( average ) );
                        }
                    }
                }
            //if ( ( vcalories( today ) + remaining_calories_estimate_based_on( average ) ) < vcalories( average )*0.9 ) {
            //    texts.add("Compared to the average of the week, you are not so active today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( average ) + " vs. " + vcalories( average ) );
            //}
            }
        } else {
            /////////////////////////////////////////////
            //   evening texts
            /////////////////////////////////////////////
            if ( vcalories( today ) < vcalories( min ) ) {
                texts.add("Take some rest today. And tomorrow, if you feel like it, try to be more active again!" + " " +  vcalories(today) + " vs. " + vcalories(min) );
                //texts.add("Confucius says: It does not matter how slowly you go as long as you do not stop." + " " +  vcalories(today) + " vs. " + vcalories(min) );
            }
            else if ( vcalories( today ) < vcalories( average ) ) {
                texts.add("Go easy today and fill up your batteries again. Maybe tomorrow you will beat the average again!" + " " +  vcalories(today) + " vs. " + vcalories(average) );
            } else {
            }
        }

        /////////////////////////////////////////////
        //   texts valid any time of the day
        /////////////////////////////////////////////

        if ( vcalories( today ) > vcalories( average ) ) {
            if ( vcalories( today ) < vcalories( max ) ) {
                texts.add("Congratulations, you beat your weekly average calories value and the day is not even over yet! Maybe you can beat the max as well?" + " " +  vcalories( today ) + " vs. " + vcalories( average ));
                texts.add("Good job! You burned more than your weekly average of calories already and the day is not even over yet!." + " " +  vcalories(today) + " vs. " + vcalories( average ) );
            } else {
                texts.add("Congratulations, you beat your weekly average calories value and the day is not even over yet! " +  vcalories( today ) + " vs. " + vcalories( average ));
            }
            if ( ( vcalories( today ) + remaining_calories_estimate_based_on( average ) )*1.1 > vcalories( average ) ) {
                texts.add("Compared to the average of the week, you are very active today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( average ) + " vs. " + vcalories( average ) );
            }
        }
        if ( vcalories( today ) < vcalories( max ) ) {
            if ( ( vcalories( today ) + remaining_calories_estimate_based_on( min ) ) > vcalories( max ) ) {
                texts.add("It is pretty likely that you will reach a new calorie record today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( min ) + " vs. " + vcalories( max ) );
            }
        }
        if ( vcalories( today ) > vcalories( max ) ) {
            texts.add("Congratulations, you set a new calories record for this week and they day is not even over yet!" + " " +  vcalories(today) + " vs. " + vcalories(max));
        }
        if ( vcalories( today ) < vcalories( samedaylastweek ) ) {
            if ( current_hour() >= 10 ) {
                if ( current_hour() <= 18 ) {
                    texts.add("Keep on it, you can still reach last weeks calorie value!" + " " + vcalories(today) + " vs. " + vcalories(samedaylastweek));
                }
            }
        }
        if ( vcalories( today ) > vcalories( samedaylastweek ) ) {
            texts.add("Congratulations, you beat last weeks calories value and the day is not even over yet!" + " " +  vcalories(today) + " vs. " + vcalories(samedaylastweek));
        }
        if ( ( vcalories( today ) + remaining_calories_estimate_based_on( samedaylastweek ) ) < vcalories( samedaylastweek )*0.9 ) {
            texts.add("Compared to the same day last week, you are not so active today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( samedaylastweek ) + " vs. " + vcalories( samedaylastweek ) );
        }
        if ( ( vcalories( today ) + remaining_calories_estimate_based_on( samedaylastweek ) ) > vcalories( samedaylastweek )*1.1 ) {
            texts.add("Compared to the same day last week, you are very active today!" + " " +  vcalories(today) + "+" + remaining_calories_estimate_based_on( samedaylastweek ) + " vs. " + vcalories( samedaylastweek ) );
        }


        // TODO three-day comparisons


/*
        if ( calories_per_hour( today )*1.1 > calories_per_hour( average ) ) {
            texts.add("(5% inc) Compared to the average, your calorie burn rate is on a good track today!" + " " +  calories_per_hour( today ) + " vs. " + calories_per_hour( average ) );
        }
        if ( calories_per_hour( today ) < calories_per_hour( average )*0.9 ) {
            texts.add("(5% less) Compared to the average, your calorie burn rate is lacking a bit..." + " " +  calories_per_hour( today ) + " vs. " + calories_per_hour( average ) );
        }
        if ( calories_per_hour( today ) > calories_per_hour( samedaylastweek ) ) {
            texts.add("Compared to last week, your calorie burn rate is on a good track today" + " " +  calories_per_hour( today ) + " vs. " + calories_per_hour( samedaylastweek ) );
        }
        if ( calories_per_hour( today ) < calories_per_hour( samedaylastweek ) ) {
            texts.add("Compared to last week, your calorie burn rate is lacking a bit..." + " " +  calories_per_hour( today ) + " vs. " + calories_per_hour( samedaylastweek ) );
        }
*/
        //if (deviation[IDX_CAL] > 0.6) {
        //    texts.add("You are extremely active (deviation is cal: " + deviation[IDX_CAL]);
        //}
        //else if (deviation[IDX_CAL] > 0.3) {
        //    texts.add("You are very active (deviation is cal: " + deviation[IDX_CAL]);
        //}
        if ( ( ( vcalories( average ) - vcalories( min ) ) / vcalories( average ) ) < 0.2) {
            if ( ( ( vcalories( max ).toFloat() - vcalories( min ).toFloat() ) / vcalories( min ).toFloat() ) < 0.2) {
                texts.add("There is not much variance in your calorie consumption. How about doing a workout today? (deviation is cal: " + deviation[IDX_CAL]);
                texts.add("Many of your calorie values are close together. Maybe you can work out more? (deviation is cal: " + deviation[IDX_CAL]);
            }
            else {
                texts.add("Many of your calorie values are close together but you are pretty active. Are you resting enough? (deviation is cal: " + deviation[IDX_CAL]);
            }
        }
        if ( ( ( vcalories( average ) - vcalories( min ) ) / vcalories( average ) ) > 0.3) {
                texts.add("You have a good balance between active days and resting days! (deviation is cal: " + deviation[IDX_CAL]);
        }

        // TODO remove
        texts.add("Your deviation is cal: " + deviation[IDX_CAL] + " step: " + deviation[IDX_STEP] + " dist: " + deviation[IDX_DIST]);


        // fallback to avoid empty string list
        if ( texts.size() == 0 ) {
            if ( current_hour() < 10 ) {
                texts.add("Good morning, today is going to be a wonderful day!");
                texts.add("With a new day comes new strength and new thoughts. - Eleanor Roosevelt");
            } else {
                texts.add("There is no quick and easy way to the body you want... commit yourself now to your workout and get started! - Tracy Anderson");
            }
        }



        /*
        if ( vsteps( today ) < vsteps( samedaylastweek ) ) {
            texts.add("Keep on it, you can still reach last weeks step count!" + " " +  vsteps(today) + " vs. " + vsteps(samedaylastweek));
        }
        if ( vsteps( today ) > vsteps( samedaylastweek ) ) {
            texts.add("Congratulations, you beat last weeks step count!" + " " +  vsteps(today) + " vs. " + vsteps(samedaylastweek));
        }
        if ( vdistance( today ) < vdistance( samedaylastweek ) ) {
            texts.add("Keep on it, you can still reach last weeks distance!" + " " +  vdistance(today) + " vs. " + vdistance(samedaylastweek));
        }
        if ( vdistance( today ) > vdistance( samedaylastweek ) ) {
            texts.add("Congratulations, you beat last weeks distance!" + " " +  vdistance(today) + " vs. " + vdistance(samedaylastweek));
        }
        */
        /*
        if ( above_average_steps( today ) ) {
            texts.add("Good job! Today you walked more steps than your weekly average." + " " +  vsteps(today) + " vs. " + vsteps( average ));
        }
        if ( above_average_distance( today ) ) {
            texts.add("Good job! Today you covered more distance than your weekly average." + " " +  vdistance(today) + " vs. " + vdistance( average ));
        }
        */

        return texts;
    }

    private function vcalories(day) {
        return day[IDX_CAL];
    }

    private function vsteps(day) {
        return day[IDX_STEP];
    }

    private function vstep_goal(day) {
        return day[IDX_STEPG];
    }

    private function vdistance(day) {
        return day[IDX_DIST];
    }

    private function calories_per_hour(day) {
        var hours_passed = day[IDX_DAY];
        return vcalories(day) / hours_passed;
    }

    private function remaining_calories_estimate_based_on(day) {
        var remaining_hours = 24 - today[IDX_DAY];
        return (vcalories(day)/day[IDX_DAY]) * remaining_hours;
    }

    private function current_hour() {
        return today[IDX_DAY];
    }

    private function above_average_steps(day) {
        return vsteps(day) > vsteps( average );
    }

    private function above_average_distance(day) {
        return vdistance(day) > vdistance( average );
    }

}


