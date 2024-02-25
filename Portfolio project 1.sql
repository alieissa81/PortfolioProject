--Temp Table
drop table if exists #percentpopulation
create table #percentpopulation
(
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric,
RollingVaccinationpopulation numeric
)
insert into #percentpopulation
select
--dea.continent,
dea.location,
cast (dea.date as date),
dea.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over(partition by dea.location order by dea.location,dea.date) RollingVaccinationpopulation
from CovidDeaths$ dea
join CovidVaccinations$ vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
group by dea.location,dea.date,dea.population,vac.new_vaccinations

--order by 1,2

select *,
(RollingVaccinationpopulation/population)*100
from #percentpopulation