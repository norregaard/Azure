# Hybrid Azure Hub-Spoke Network (ExpressRoute + VPN overlay)

```mermaid
flowchart LR
  %% Layout: left-to-right

  %% On-Premises
  subgraph OnPrem["On‑Premises"]
    OPWAN[("Core Network")] 
    OPVPN["VPN Gateway / Device"]
  end

  %% Colocation / Peering Facility (where MSEE resides)
  subgraph Colo["Colocation Peering Facility"]
    MSEE["MSEE (Microsoft Enterprise Edge)"]
  end

  %% Azure
  subgraph Azure["Azure"]
    direction LR
    %% Hub VNet contains gateways and firewall
    subgraph Hub["Hub VNet"]
      direction TB
      ERGW["ExpressRoute Gateway"]
      VPNGW["Azure VPN Gateway"]
      AFW["Azure Firewall"]
    end
    %% Spoke VNets (stacked to the right)
    subgraph Spokes["Spoke VNets (Landing Zones)"]
      direction TB
      SP_PAD[" "]
      S1["Spoke VNet 1"]
      S2["Spoke VNet 2"]
      S3["Spoke VNet 3"]
    end
  end

  %% On-prem core to VPN device
  OPWAN --> OPVPN

  %% On‑prem to colocation uses a WAN link; ER circuit is from MSEE to Azure
  OPVPN -- "WAN link" --> MSEE

  %% ExpressRoute circuit from MSEE to the Azure ER Gateway
  MSEE -- "ExpressRoute Circuit (Private Peering)" --> ERGW

  %% Sequence on Azure side: ER GW → VPN GW → Firewall
  ERGW --> VPNGW
  VPNGW --> AFW
  %% Spokes connect directly to Azure Firewall
  AFW --- S1
  AFW --- S2
  AFW --- S3

  %% (Spokes removed for simplified hub-only view)

  %% Styling
  classDef gw fill:#eefcf2,stroke:#2f855a,stroke-width:1px,color:#1c4532
  classDef security fill:#fff5e6,stroke:#b76e00,stroke-width:1px,color:#5a3a00
  classDef infra fill:#eef6ff,stroke:#1e60d4,stroke-width:1px,color:#0b3a8f
  class ERGW,VPNGW,OPVPN,OPWAN,MSEE gw
  class AFW security
  class S1,S2,S3 infra
  class SP_PAD pad
  classDef pad fill:transparent,stroke:transparent,color:transparent
```

Notes:
- Single ExpressRoute circuit runs from MSEE at the colocation peering facility to the Azure ExpressRoute Gateway; the on‑prem to colo segment is a WAN link.
- A VPN overlay runs end‑to‑end (WAN link + ExpressRoute) between the on‑prem VPN device and the Azure VPN Gateway; traffic flows ER GW → VPN GW → Azure Firewall within the Hub VNet.
 - Three spokes connect directly to the Azure Firewall via VNet peering to the Hub VNet (using UDRs associated with subnets).
