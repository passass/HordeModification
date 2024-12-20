-- Добавлено
local shortcuts = {
    ["slomo_rpm&reload"] = "{slomo1} увеличивает скорость перезарядки и скорострельность в замедленном времени. ({slomo2} за уровень, до {slomo3}).",
    ["slomo_ms&atksp"] = "{slomo1} увеличивает скорость передвижения и скорость атаки в замедленном времени. ({slomo2} за уровень, до {slomo3})."
}

translate.AddLanguage("ru", "Russian")
LANGUAGE["Shop_Grip"] = "Рукоять"

LANGUAGE["Item_50 Kevlar Armor"] = "50 Кевларовой брони"
LANGUAGE["Item_100 Kevlar Armor"] = "100 Кевларовой брони"
LANGUAGE["Item_150 Kevlar Armor"] = "150 Кевларовой брони"
LANGUAGE["Item_200 Kevlar Armor"] = "200 Кевларовой брони"

LANGUAGE["Pros"] = "Плюсы"
LANGUAGE["Cons"] = "Минусы"
LANGUAGE["Shop_Buy_Ammo_All"] = "Пополнить полностью"
LANGUAGE["Shop_UpgradeTo"] = "Улучшить"

LANGUAGE["Perk_samurai_base"] = [[
СЛОЖНОСТЬ: ВЫСОКАЯ

Наносит нарастающее кровотечение на {1} от базового урона в ближнем бою. ({2} + {3} за каждый уровень, до {4}).
На {5} увеличена устойчивость к любому урону. ({6} за каждый уровень, до {7}).
]] .. shortcuts["slomo_ms&atksp"] .. [[

SHIFT+E чтобы активировать рывок.
Вы мчитесь в направлении движения.
На 100% увеличено уклонение при рывке.
]]

LANGUAGE["Item_Sonar Grenade"] = [[Ледяная граната]]
LANGUAGE["Item_Desc_Sonar Grenade"] = [[
Замораживает ближайших врагов.
]]

LANGUAGE["Perk_survivor_base"] = [[
Класс "Выживший" может быть включен в любой класс, чтобы занять недостающие роли для команды.
Cложность: ЛЁГКАЯ

на {damageincrease1} увеличен урон. ({damageincrease2} за уровень, до {damageincrease3}).
на {movement1} увеличена скорость передвижения. ({movement2} за уровень, до {movement3}).
{slomo1} увеличивает скорость перезарядки и скорость передвижения в замедленном времени. ({slomo2} за уровень, до {slomo3}).
получает случайное стартовое оружие.]]

LANGUAGE["Perk_assault_base"] = [[
Класс "Штурмовик" - это универсальный боец, обладающий высокой мобильностью и ориентированный на выброс адреналина.
Cложность: ЛЁГКАЯ

Может видеть невидимых существ.

На {1} увеличена скорость передвижения. ({2} за каждый уровень, до {3}).
{4} увеличен баллистический урон. ({5} за каждый уровень, до {6}).
]] .. shortcuts["slomo_rpm&reload"] .. [[
7 стаков слоумо вместо 3.

Вы получаете адреналин, когда убиваете врага.
Адреналин увеличивает урон и скорость на {7}.]]

LANGUAGE["Perk_berserker_base"] = [[
Класс "Берсеркер" - это класс, сосредоточенный на ближний бой, за которого можно играть и нападая, и обороняясь.
Cложность: ВЫСОКАЯ

На {1} увеличен урон от рубящих и тупых ударов. ({2} за каждый уровень, до {3}).
На {4} увеличена устойчивость к любому урону. ({5} за каждый уровень, до {6}).
]] .. shortcuts["slomo_ms&atksp"] .. [[

Воздушное парирование: Прыгните, чтобы уменьшить физический урон на {10}.]]

LANGUAGE["Perk_swat_base"] = [[
SWAT это очень боеспособный класс.
Сложность: ЛЁГКАЯ

{1} Быстрее смена оружия. ({2} за уровень, до {3}).
{4} Быстрее перезарядка оружия. ({5} за уровень, до {6}).
]] .. shortcuts["slomo_rpm&reload"]

LANGUAGE["Perk_heavy_base"] = [[
Класс "Тяжеловес" это класс танка, обеспечивающий сильную огневую мощь подавления.
Cложность: ЛЁГКАЯ

На {6} увеличено количество максимальной брони. ({7} за каждый уровень, до {8}).
]] .. shortcuts["slomo_rpm&reload"] .. [[

Регенерирует {1} брони за секунду.
Регенерирует до {2} брони. ({3} + {4} за каждый уровень, до {5})
]]

LANGUAGE["Perk_gunslinger_base"] = [[
На {1} увеличен урон от пистолета. ({2} за каждый уровень, до {3}).
Ваши пистолеты могут быть улучшены в магазине для увеличенного урона.

Нажмите SHIFT+E, чтобы нанести метку охотника на врага.
Метка охотника длится в течение 5 секунд.
Вы можете нанести 1 метку охотника за раз.
Враги, убитые под меткой охотника, имеют {4} шанс сбросить дополнительные деньги.

]] .. shortcuts["slomo_rpm&reload"] .. [[

Имеет доступ ко всем пистолетам.]]

LANGUAGE["Perk_specops_base"] = [[
Класс "Спецназ" фокусируется на эффектах своего уникального тактического режима.
СЛОЖНОСТЬ: СРЕДНЯЯ

Нажмите на F, чтобы войти в тактический режим, заменяющий ваш фонарь.
У вас имеется ночное видение в тактическом режиме.
Вы не можете бегать в тактическом режиме.
На 50% понижена скорость передвижения в тактическом режиме.

На {1} увеличена скорость передвижения в тактическом режиме. ({2} за каждый уровень, до {3})
На {1} увеличен урон при подании в голову в тактическом режиме. ({2} за каждый уровень, до {3})
]] .. shortcuts["slomo_rpm&reload"]

LANGUAGE["Perk_demolition_base"] = [[
Класс "Подрывник" - это класс контроля толпы, который также может наносить высокий урон по одной цели.
Cложность: СРЕДНЯЯ

На {7} увеличен урон от взрыва. ({8} за каждый уровень, до {9}).
На {1} повышена устойчивость ко взрыву. ({2} + {3} за каждый уровень, до {4}).
]] .. shortcuts["slomo_rpm&reload"] .. [[

Создается {5} осколочная граната каждые {6} секунд, если у вас её нету.]]

LANGUAGE["Perk_survivor_rapidslomo"] = [[делает стрельбу в замедленном времени быстрее.
сильно снижает отдачу в замедленном времени.]]

LANGUAGE["Perk_ghost_base"] = [[
Класс "Призрак" сосредоточен на уничтожение боссов используя Камуфляж.
Cложность: ВЫСОКАЯ

На {1} больше урона в голову. ({2} за каждый уровень, до {3}).
{slomo1} увеличивает скорость перезарядки, скорострельность, перетягивание затвора и скорость прицеливания в замедленном времени. ({slomo2} за уровень, до {slomo3}).

Присядьте, чтобы активировать Камуфляж, предоставляющий {4} уклонения.
Атака или бег СНИМАЮТ Камуфляж.]]