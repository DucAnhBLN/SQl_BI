Create Database MobileGame;
use MobileGame;


select *
from MobileGame

select count(*) as count, AverageUserRating
from MobileGame
group by AverageUserRating
order by count


Update MobileGame
set Original_Release_Date = Format(Convert(Datetime,Left(Original_Release_Date,19),120),'yyyy-MM-dd');

select count(distinct(Name))
from MobileGame

select round(AVG(UserRatingCount),0) as AverageRating, Sum(UserRatingCount) as TotalRating
from MobileGame

select *
from MobileGame 
order by AverageUserRating DESC




-- Number of User raing with game by price
select round(AVG(AverageUserRating),0) as av, Sum(UserRatingCount) as Sum_user, price_group, count(*) as count_game
from
(select Case
	when Price = 0 then 'Free'
	when Price = 1.99 then '1.99'
	when Price = 2.99 then '2.99'
	when Price = 3.99 then '3.99'
	Else 'other' End as price_group, UserRatingCount, AverageUserRating
from MobileGame) as subquery
group by price_group
order by count_game DESC, price_group DESC



-- Number of AgeRating_group

select AgeRating, count(*) as GameNumber, Sum(UserRatingCount) as GamerRating
from MobileGame
group by AgeRating
order by GameNumber




-- Number of rating by In App purchases
select InAppPurchase_group , count(*) as Number_of_game , Sum(UserRatingCount) as total_rating
from
(select case
	when In_appPurchases is null then 'no'
	when In_appPurchases = 1.99 then '1.99'
	when In_appPurchases = 2.99 then '2.99'
	when In_appPurchases = 3.99 then '3.99'
	else 'other' end InAppPurchase_group, UserRatingCount
from MobileGame) as subquery
group by InAppPurchase_group
order by total_rating


-- Language used in game

select LanguageUsed, count(*) as GamesNumber ,Sum(UserRatingCount) as total_rating
from
(select  
case
	when Languages = 'EN' then 'EN'
	else 'other' end as LanguageUsed, UserRatingCount
from MobileGame 
) as subquery
group by LanguageUsed
order by total_rating DESC 


select Max(Size) as Maxx, Min(Size) as Minn, AVG(Size) as average 
from MobileGame

select (Max(Size) - Min(Size))/3 as distance
from MobileGame

select Max(Size)-1 as dis
from MobileGame


select * 
from MobileGame


-- Size distribution
select Size_group, count(*) as GamesNumber ,Sum(UserRatingCount) as total_rating
from
(select case
	when Size < 4005591039/1000 then 'Small'
	when Size < 4005591039/100 then 'Medium'
	else 'Large' 
End as Size_group,  UserRatingCount
from MobileGame) as subquery
group by Size_group

select count(*) as GamesNumber, Sum(UserRatingCount) as total_rating, PrimaryGenre
from MobileGame
group by PrimaryGenre
order by GamesNumber DESC

-- Year of Game

select Age_of_Game, Sum(UserRatingCount) as total_rating
from
(select (datediff(year, CurrentVersionReleaseDate, getdate())) as Age_of_Game ,UserRatingCount
from MobileGame) as subquery
group by Age_of_Game
order by Age_of_Game