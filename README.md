# LSTM-based-Object-Recognition-from-Tactile-and-Kinesthetic-Information

## Abstract
Recent advances in the field of intelligent robotic manipulation pursue providing  robotic  hands  with  touch  sensitivity.  Haptic  perception  encompasses  the  sensing  modalities  encountered  in  thesense  of  touch  (e.g.,  tactile  and  kinesthetic  sensations).  This letter  focuses  on  multimodal  object  recognition  and  proposes a   Bayesian   methodology   for   the   optimal   fusion   of   tactile-and  kinesthetic-based  classification  results.  The  procedure  is as  follows:  a  three-finger  actuated  gripper  with  an  integrated high-resolution tactile sensor performs squeeze-and-release Ex-ploratory Procedures (EPs). The tactile images and kinesthetic information acquired using angular sensors on the finger joints constitute  the  time-series  datasets  of  interest.  Each  temporal dataset  is  fed  to  a  Long  Short-term  Memory  (LSTM)  NeuralNetwork,  which  is  trained  to  classify  in-hand  objects.  TheLSTMs   provide   an   estimation   of   the   posterior   probability of  each  object  given  the  corresponding  measurements,  which after  fusion  allows  to  estimate  the  object  through  maximum  aposteriori  (MAP).  An  experiment  with  36-classes  is  carried out  to  evaluate  and  compare  the  performance  of  the  fused, tactile,  and  kinesthetic  perception  systems.  The  results  show that the fusion-based algorithm improves capabilities for object-recognition.

## Dataset
The dataset is divided in two parts: kinesthetic and tactile data. This dataset is formed by 36 objects, wich has been divided in three subgroups, depending on their internal characteristics.

* **Rigid Objects**

These objects are considered as rigid due to they barely change their shape when the gripper tightens them.

* **Deformable Objects**

Deformable objects change substantially his initial shape when a pressure is applied over them, but they recover its initial shape when the pressure ends.
* **In-bag Objects**

 The last group is composed by plastic bags with a number of small objects. Bags are shuffled before every grasp, so that the objects in the bag are placed in different positions.

## Cite this work

 Francisco Pastor, Jorge Garcıa-Gonzalez, Juan M. Gandarias, Daniel Medina, Alfonso J. Garcıa-Cerezo, Jesus M. Gomez-de-Gabriel, "Bayesian  and  Neural  Inference  on  LSTM-based  Object  Recognitionfrom  Tactile  and  Kinesthetic  Information"
