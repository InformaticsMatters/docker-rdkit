package foo;

import org.RDKit.*;

public class MorganFP {

  public static void main(String[] args) {

    System.loadLibrary("GraphMolWrap");
    
    System.out.println("RDKit version: " +  RDKFuncs.getRdkitVersion());
    
    String smiles = "Cc1ccccc1";
    RWMol m = RWMol.MolFromSmiles(smiles);


    SparseIntVectu32 fp = RDKFuncs.MorganFingerprintMol(m, 2);

    System.out.println("MorganFP: " + fp.size());
  }
}
