
data RhType = Pos | Neg

data ABOType = A | B | AB | O

data BloodType = BloodType ABOType RhType


showRh :: RhType -> String
showRh Pos = "+"
showRh Neg = "-"

showABO :: ABOType -> String
showABO A  = "A"
showABO B  = "B"
showABO AB = "AB"
showABO O  = "O"

showBloodType :: BloodType -> String
showBloodType (BloodType abo rh) = showABO abo ++ showRh rh

canDonateTo :: BloodType -> BloodType -> Bool
canDonateTo (BloodType O _) _                = True -- universal donor
canDonateTo _               (BloodType AB _) = True -- universal receiver
canDonateTo (BloodType A _) (BloodType A  _) = True
canDonateTo (BloodType B _) (BloodType B  _) = True
canDonateTo _               _                = False -- Otherwise

patient1BT :: BloodType
patient1BT = BloodType A Pos

patient2BT :: BloodType
patient2BT = BloodType O Neg

patient3BT :: BloodType
patient3BT = BloodType AB Pos


data Sex = Male | Female

showSex :: Sex -> String
showSex Male   = "Male"
showSex Female = "Female"

type FirstName = String
type MiddleName = String
type LastName = String
data Name = Name FirstName LastName
          | NameWithMiddle FirstName MiddleName LastName

showName :: Name -> String
showName (Name f l            ) = f ++ " " ++ l
showName (NameWithMiddle f m l) = f ++ " " ++ m ++ " " ++ l

name1 = Name "Jerome" "Salinger"
name2 = NameWithMiddle "Jerome" "David" "Salinger"

data Patient = Patient { name :: Name
                       , sex :: Sex
                       , age :: Int
                       , height :: Int
                       , weight :: Int
                       , bloodType :: BloodType
                       }


jackieSmith :: Patient
jackieSmith = Patient { name      = Name "Jackie" "Smith"
                      , age       = 43
                      , sex       = Female
                      , height    = 62
                      , weight    = 115
                      , bloodType = BloodType O Neg
                      }


jackieSmithName = showName (name jackieSmith)

jackieSmithUpdated = jackieSmith { age = 44 }


-- Q 12.1
-- write a function similar to canDonateTo that takes two patients as 
-- arguments rather than two BloodTypes
canDonateToPatient :: Patient -> Patient -> Bool
canDonateToPatient p1 p2 = canDonateTo (bloodType p1) (bloodType p2)


-- Q 12.2
patientSummary :: Patient -> String
patientSummary p =
    "**************"
        ++ "\n"
        ++ "Patient Name: "
        ++ showName (name p)
        ++ "\n"
        ++ "Sex: "
        ++ showSex (sex p)
        ++ "\n"
        ++ "Age: "
        ++ show (age p)
        ++ "\n"
        ++ "Height: "
        ++ show (height p)
        ++ "\n"
        ++ "Weight: "
        ++ show (weight p)
        ++ "\n"
        ++ "BloodType: "
        ++ showBloodType (bloodType p)
        ++ "\n"
        ++ "**************"

