package foo;

import org.RDKit.*;

public class Standardize {

  public static void main(String[] args) {

    System.loadLibrary("GraphMolWrap");
    
    System.out.println("RDKit version: " +  RDKFuncs.getRdkitVersion());
    
    String smiles = "[Na]OC(=O)c1ccccc1";
    RWMol m = RWMol.MolFromSmiles(smiles);
    CleanupParameters params = RDKFuncs.getDefaultCleanupParameters();

    m = RDKFuncs.cleanup(m, params);
    m = RDKFuncs.chargeParent(m, params, false);

    System.out.println("Mol: " + m);
  }
}
